# SPDX-License-Identifier: MIT
# Copyright (c) 2026 K. S. Ernest (iFire) Lee
defmodule Uro.Repository do
  @moduledoc ~S"""
  Where Uro keeps its data.

  `Uro.Repository.Repo` is the SQLite repo. It sets `priv: "priv/repo"` so Ecto finds the
  migrations in `priv/repo/migrations`. The lobby list itself is held in memory and writes
  nothing here.
  """
end
