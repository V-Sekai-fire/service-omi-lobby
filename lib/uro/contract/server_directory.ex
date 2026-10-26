# SPDX-License-Identifier: MIT
# Copyright (c) 2026 K. S. Ernest (iFire) Lee
defmodule Uro.Contract.ServerDirectory do
  @moduledoc """
  Port: lists the servers a public directory knows to be active. The lobby use case calls
  this; an outbound adapter (`Uro.Datasource.Overte.Directory`) answers it.
  Configure another adapter with `config :uro, :lobby_server_directory, MyAdapter`.
  """

  @callback fetch() :: {:ok, [map()]} | {:error, term()}
end
