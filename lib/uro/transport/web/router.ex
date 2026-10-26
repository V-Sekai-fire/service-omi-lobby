# SPDX-License-Identifier: MIT
# Copyright (c) 2026 K. S. Ernest (iFire) Lee
defmodule Uro.Transport.Web.Router do
  use Uro.Transport.Web, :router
  use Plug.ErrorHandler
  use Uro.Transport.Web.Helpers.API

  # The status is the exception's own, so an unknown route is a 404 and not a 500, and an
  # exit (a crashed task) still gets a JSON body instead of dropping the connection.
  defp handle_errors(conn, %{reason: reason}) do
    json_error(conn,
      code: reason |> Plug.Exception.status() |> Plug.Conn.Status.reason_atom(),
      message:
        if(is_exception(reason), do: Exception.message(reason), else: "Internal Server Error")
    )
  end

  defp handle_errors(conn, _) do
    json_error(conn, code: :internal_server_error)
  end

  pipeline :api do
    plug(:accepts, ["json"])
    plug(:fetch_session)

    plug(RemoteIp)
    plug(Uro.Transport.Web.Plugs.Authentication, otp_app: :uro)

    plug(OpenApiSpex.Plug.PutApiSpec, module: Uro.Contract.OpenAPI.Specification)
  end

  pipeline :authenticated do
    plug(Pow.Plug.RequireAuthenticated,
      error_handler: Uro.Transport.Web.Controllers.Fallback
    )
  end

  pipeline :authenticated_admin do
    plug(Pow.Plug.RequireAuthenticated,
      error_handler: Uro.Transport.Web.Controllers.Fallback
    )

    plug(Uro.Transport.Web.Plugs.RequireAdmin)
  end

  pipeline :authenticated_shared_file do
    plug(Uro.Transport.Web.Plugs.RequireSharedFileUploadPermission)
  end

  pipeline :authenticated_user do
    plug(Uro.Transport.Web.Plugs.ChooseAuth)
  end

  if Mix.env() == :dev do
    pipeline :browser do
      plug(:accepts, ["html"])
      plug(:fetch_session)
      plug(:fetch_flash)
      plug(:protect_from_forgery)
      plug(:put_secure_browser_headers)
    end

    scope "/" do
      pipe_through([:browser])

      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end

  # Health — root level, no pipeline (monitoring tools hit this directly).
  get("/", Uro.Transport.Web.Controllers.Health, :index)
  get("/health", Uro.Transport.Web.Controllers.Health, :index)

  # All API routes under /api/v1.
  scope "/api/v1" do
    pipe_through([:api])

    get("/openapi", OpenApiSpex.Plug.RenderSpec, [])
    get("/docs", Uro.Contract.OpenAPI.Viewer, [])

    scope "/registration" do
      post "/", Uro.Transport.Web.Controllers.User, :create_client
    end

    scope "/profile" do
      pipe_through([:authenticated_user])
      get("/", Uro.Transport.Web.Controllers.User, :show_current)
      post("/totp", Uro.Transport.Web.Controllers.SecondFactor, :begin_totp)
      post("/totp/confirm", Uro.Transport.Web.Controllers.SecondFactor, :confirm_totp)
      delete("/totp", Uro.Transport.Web.Controllers.SecondFactor, :disable_totp)
      get("/passkeys", Uro.Transport.Web.Controllers.Passkey, :index)

      post(
        "/passkeys/challenge",
        Uro.Transport.Web.Controllers.Passkey,
        :registration_challenge
      )

      post("/passkeys", Uro.Transport.Web.Controllers.Passkey, :register)
      delete("/passkeys/:id", Uro.Transport.Web.Controllers.Passkey, :delete)
    end

    scope "/session" do
      post("/", Uro.Transport.Web.Controllers.Authentication, :login_client)

      scope "/renew" do
        post("/", Uro.Transport.Web.Controllers.Authentication, :renew)
      end

      pipe_through([:authenticated_user])

      get("/", Uro.Transport.Web.Controllers.Authentication, :get_current_session)
      delete("/", Uro.Transport.Web.Controllers.Authentication, :logout)
    end

    scope "/device" do
      post("/code", Uro.Transport.Web.Controllers.DeviceGrant, :code)
      post("/token", Uro.Transport.Web.Controllers.DeviceGrant, :token)

      pipe_through([:authenticated_user])

      get("/", Uro.Transport.Web.Controllers.DeviceGrant, :show)
      post("/approve", Uro.Transport.Web.Controllers.DeviceGrant, :approve)
      post("/deny", Uro.Transport.Web.Controllers.DeviceGrant, :deny)
    end

    scope "/login" do
      post("/", Uro.Transport.Web.Controllers.Authentication, :login)
      post("/passkey/challenge", Uro.Transport.Web.Controllers.Passkey, :login_challenge)
      post("/passkey", Uro.Transport.Web.Controllers.Passkey, :login)

      scope "/:provider" do
        get("/", Uro.Transport.Web.Controllers.Authentication, :login_with_provider)
        get("/callback", Uro.Transport.Web.Controllers.Authentication, :provider_callback)
      end
    end

    get "/lobby/servers", Uro.Transport.Web.Controllers.Lobby, :servers

    scope "/admin" do
      pipe_through([:authenticated_admin])

      get("/", Uro.Transport.Web.Controllers.Admin, :status)
      post("/users/:id/confirm", Uro.Transport.Web.Controllers.Admin, :confirm_user)
    end

    scope "/storage" do
      scope "/tag" do
        get "/:tag", Uro.Transport.Web.Controllers.Storage, :index_by_tag
      end

      get "/:id", Uro.Transport.Web.Controllers.Storage, :show

      pipe_through([:authenticated_shared_file])

      get "/", Uro.Transport.Web.Controllers.Storage, :index
      post "/", Uro.Transport.Web.Controllers.Storage, :create
      put "/:id", Uro.Transport.Web.Controllers.Storage, :update
      delete "/:id", Uro.Transport.Web.Controllers.Storage, :delete
    end

    scope "/users" do
      post "/", Uro.Transport.Web.Controllers.User, :create

      scope "/" do
        pipe_through([:authenticated])
        get "/", Uro.Transport.Web.Controllers.User, :index
      end

      scope "/:user_id" do
        get "/", Uro.Transport.Web.Controllers.User, :show
        post "/email", Uro.Transport.Web.Controllers.User, :confirm_email

        scope "/" do
          pipe_through([:authenticated])

          patch "/", Uro.Transport.Web.Controllers.User, :update

          put "/email", Uro.Transport.Web.Controllers.User, :update_email
          patch "/email", Uro.Transport.Web.Controllers.User, :resend_confirmation_email
        end
      end
    end

    scope "/dashboard" do
      pipe_through([:authenticated_user])

      get("/", Uro.Transport.Web.Controllers.Authentication, :get_current_session)
      delete("/", Uro.Transport.Web.Controllers.Authentication, :logout)
    end
  end
end
