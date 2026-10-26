# SPDX-License-Identifier: MIT
# Copyright (c) 2026 K. S. Ernest (iFire) Lee
defmodule Uro.Transport.Web do
  @moduledoc """
  Multiplayer Fabric zone backend (Uro) — Phoenix/Elixir API server.

  ## Service topology

  ```
  Internet
    │
    ▼
  Cloudflare edge  (orange cloud ON, Full strict SSL)
    │  hub-700a.chibifire.com  DNS A → 173.180.240.105
    ▼
  Caddy:443  (Cloudflare Origin Certificate)
    │  /api/v1/*   → uro:4000   (prefix stripped before proxying)
    │  /uploads/*  → uro:4000
    │  /*          → frontend:3000  (Next.js web UI; not required for PoC)
    ▼
  uro:4000  (this application, Phoenix/Bandit)
    ├── uro.db            SQLite file, in-process
    └── versitygw:7070    VersityGW S3-compatible object store (POSIX backend)
  ```

  ## Key design decisions

  ### Cloudflare Origin Certificate for HTTP

  HTTP traffic is proxied by Cloudflare (Full strict mode). Caddy holds a
  Cloudflare Origin Certificate.

  ## Data model

  ```
  users
    id (uuid)  email  username  display_name

  user_identities
    provider ("pow_assent" | …)  uid  → users

  shared_files
    id (uuid)  name  tags[]  is_public
    store_url     raw upload location (VersityGW)
    chunks        [{hash, offset, length}] jsonb
    baked_url     .caidx index URL (set after baker completes)
    uploader_id → users
  ```

  ## Using this module

  Controllers and views call `use Uro.Transport.Web, :controller` (etc.) to pull
  in standard imports:

      use Uro.Transport.Web, :controller
      use Uro.Transport.Web, :view
  """

  def mailer_view do
    quote do
      use Phoenix.View,
        root: "lib/uro_web/templates",
        namespace: Uro

      use Phoenix.HTML
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, namespace: Uro
      use Uro.Transport.Web.Helpers.API
      use OpenApiSpex.ControllerSpecs

      import Plug.Conn
      import Uro.Transport.Web.Gettext
      import Uro.Interactor.Users

      # alias Uro.Transport.Web.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/uro_web/templates",
        namespace: Uro

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import Uro.ErrorHelpers
      import Uro.Transport.Web.Gettext
      # alias Uro.Transport.Web.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
