# SPDX-License-Identifier: MIT
# Copyright (c) 2026 K. S. Ernest (iFire) Lee
defmodule Uro.Interactor do
  @moduledoc ~S"""
  The application services: what Uro does, step by step.

  `Lobby`, `Accounts`, `Passkeys`, `SecondFactor`, `DeviceGrant`, `SharedContent`,
  `UserIdentities` and `Users`. An interactor returns `{:ok, value}` or `{:error, reason}` and
  reaches the outside only through a `Uro.Contract` behaviour or the repository.
  """
end
