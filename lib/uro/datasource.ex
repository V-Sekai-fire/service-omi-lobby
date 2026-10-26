# SPDX-License-Identifier: MIT
# Copyright (c) 2026 K. S. Ernest (iFire) Lee
defmodule Uro.Datasource do
  @moduledoc ~S"""
  Where the lobby reads live server data.

  `Uro.Datasource.Basis.Query` asks a Basis server for its status over UDP and answers
  `Uro.Contract.ServerProbe`. `Uro.Datasource.Overte.Directory` reads the public Overte
  directory over HTTP and answers `Uro.Contract.ServerDirectory`.
  """
end
