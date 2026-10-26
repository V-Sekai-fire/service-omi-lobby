# SPDX-License-Identifier: MIT
# Copyright (c) 2026 K. S. Ernest (iFire) Lee
defmodule Uro.Contract do
  @moduledoc ~S"""
  The behaviours interactors call, and the OpenAPI specification.

  `Uro.Contract.ServerProbe` asks one game server for its status. `Uro.Contract.ServerDirectory`
  lists the servers a public directory knows to be active. `Uro.Contract.OpenAPI.Specification`
  describes the HTTP API.

  ## Swapping a datasource

  The lobby interactor reads its probe and directory from config, so a test or another
  platform can bring its own:

      config :uro, :lobby_server_probe, MyApp.FakeProbe
      config :uro, :lobby_server_directory, MyApp.FakeDirectory
  """
end
