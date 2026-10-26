# SPDX-License-Identifier: MIT
# Copyright (c) 2026 K. S. Ernest (iFire) Lee
defmodule Uro.Transport do
  @moduledoc ~S"""
  What drives Uro from outside: the Phoenix web app and the lobby poller.

  `Uro.Transport.Web` holds the endpoint, router, controllers, plugs, helpers and the
  `use Uro.Transport.Web` macro. `Uro.Transport.Poller` polls the lobby on a timer and calls
  `Uro.Interactor.Lobby`. Transport calls interactors and never reaches a datasource directly.
  """
end
