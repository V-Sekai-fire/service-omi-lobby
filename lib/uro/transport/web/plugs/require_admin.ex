# SPDX-License-Identifier: MIT
# Copyright (c) 2026 K. S. Ernest (iFire) Lee
defmodule Uro.Transport.Web.Plugs.RequireAdmin do
  import Plug.Conn

  @doc false
  def init(options), do: options

  @doc false
  @spec call(Conn.t(), atom()) :: Conn.t()
  def call(conn, handler) do
    conn
    |> Uro.Transport.Web.Helpers.Admin.session_admin?()
    |> maybe_halt(conn, handler)
  end

  @doc false
  defp maybe_halt(true, conn, _handler), do: conn

  @doc false
  defp maybe_halt(false, conn, _handler) do
    conn
    |> put_status(403)
    |> send_resp(403, "Unauthorized 403")
    |> halt()
  end
end
