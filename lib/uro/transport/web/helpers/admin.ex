# SPDX-License-Identifier: MIT
# Copyright (c) 2026 K. S. Ernest (iFire) Lee
defmodule Uro.Transport.Web.Helpers.Admin do
  @moduledoc """
  Admin helper functions, automatically imported by controllers.
  """

  alias Uro.Entities.Accounts.User
  alias Uro.Transport.Web.Helpers.Auth

  def session_admin?(conn) do
    user = Auth.get_current_user(conn)
    User.admin?(user)
  end
end
