# SPDX-License-Identifier: MIT
# Copyright (c) 2026 K. S. Ernest (iFire) Lee
import Config

config :uro, Uro.Transport.Web.Endpoint,
  debug_errors: true,
  code_reloader: true,
  check_origin: false

config :uro, Uro.Service.Mailer, adapter: Swoosh.Adapters.Local

config :open_api_spex, :cache_adapter, OpenApiSpex.Plug.NoneCache

config :logger, :console, format: "[$level] $message\n"
config :logger, level: :debug

config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime

config :uro, Uro.Repository.Repo,
  show_sensitive_data_on_connection_error: true,
  database: System.get_env("URO_DATABASE", Path.expand("../priv/uro_dev.db", __DIR__)),
  stacktrace: true,
  migration_lock: false,
  pool_size: 10

config :uro, :webauthn, origin: "http://localhost:4000", rp_id: "localhost"
config :uro, :device_verification_uri, "http://localhost:4000/device"

# `mix phx.server` listens on 127.0.0.1:4000 and the site (`pnpm dev`) on port 3000.
# The values below are for this machine only; prod reads its own from config/runtime.exs.
config :uro, Uro.Transport.Web.Endpoint,
  adapter: Bandit.PhoenixAdapter,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  server: true,
  url: [scheme: "http", host: "localhost", port: 4000],
  secret_key_base: String.duplicate("uro-dev-key-base-", 4)

config :uro,
  url: URI.new!("http://localhost:4000"),
  frontend_url: URI.new!("http://localhost:3000"),
  root_origin: URI.new!("http://localhost:3000")

config :uro, :device_verification_uri, "http://localhost:3000/device"
config :uro, :webauthn, origin: "http://localhost:3000", rp_id: "localhost"
config :joken, default_signer: "uro-dev-signer"
