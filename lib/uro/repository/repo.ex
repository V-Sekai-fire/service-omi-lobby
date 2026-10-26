# SPDX-License-Identifier: MIT
# Copyright (c) 2026 K. S. Ernest (iFire) Lee
defmodule Uro.Repository.Repo do
  use Ecto.Repo,
    otp_app: :uro,
    priv: "priv/repo",
    adapter: Ecto.Adapters.SQLite3,
    migration_lock: false

  use Scrivener, page_size: 10
end
