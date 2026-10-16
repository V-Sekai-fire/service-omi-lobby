# SPDX-License-Identifier: MIT
# Copyright (c) 2026 K. S. Ernest (iFire) Lee
import Config

# Everything that needs a real deploy-time secret or URL now lives in
# config/runtime.exs, evaluated once at release boot, not here. This
# file only holds config that is genuinely safe to bake in at compile
# time (mix release freezes this file's content permanently into the
# release, evaluated once, at build time -- unlike runtime.exs, which
# the release re-evaluates every time it actually starts).
config :hammer,
  backend: {Hammer.Backend.ETS, [expiry_ms: 60_000 * 60 * 4, cleanup_interval_ms: 60_000 * 10]}

config :uro,
  ecto_repos: [Uro.Repo]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

# The OMI lobby lists these Basis servers (host:port of the game port) and probes them.
config :uro, :lobby_basis_servers, ["server1.basisvr.org:4296"]

config :uro, :pow,
  user: Uro.Accounts.User,
  users_context: Uro.Accounts,
  repo: Uro.Repo,
  web_module: Uro,
  extensions: [PowPersistentSession],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks,
  routes_backend: Uro.Pow.Routes,
  cache_store_backend: Uro.Pow.DetsCache

config :uro, :pow_assent, user_identities_context: Uro.UserIdentities

config :uro, :registration_open, false

config :waffle,
  storage: Waffle.Storage.Local

import_config "#{Mix.env()}.exs"

if Mix.env() == "dev" do
  import_config "local.exs"
end
