# SPDX-License-Identifier: MIT
# Copyright (c) 2026 K. S. Ernest (iFire) Lee
defmodule Uro.Contract.ServerProbe do
  @moduledoc """
  Port: asks one game server for its status. The lobby use case calls this; an outbound
  adapter (`Uro.Datasource.Basis.Query`) answers it. Configure another adapter
  with `config :uro, :lobby_server_probe, MyAdapter`.
  """

  @type info :: %{
          name: String.t() | nil,
          motd: String.t() | nil,
          online: non_neg_integer() | nil,
          capacity: non_neg_integer() | nil
        }

  @callback probe(host :: String.t() | charlist(), port :: :inet.port_number()) ::
              {:ok, info()} | {:error, term()}
end
