# SPDX-License-Identifier: MIT
# Copyright (c) 2026 K. S. Ernest (iFire) Lee
import Config

config :uro, Uro.Repo,
  show_sensitive_data_on_connection_error: true,
  database: System.get_env("TEST_DATABASE", Path.expand("../priv/uro_test.db", __DIR__)),
  stacktrace: true,
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :uro, :webauthn, origin: "https://uro.test", rp_id: "uro.test"
config :uro, :device_verification_uri, "https://uro.test/device"

# Sessions and sealed second factors need a key base; the server stays off.
config :uro, Uro.Endpoint,
  server: false,
  secret_key_base: String.duplicate("uro-test-key-base-", 4)

# The tests release leases themselves; the janitor stays out of the sandbox.
config :uro, :agent_task_janitor_interval, 24 * 60 * 60 * 1000

# No collector in tests; tools/offline turns the exporter on against its own suite.
config :opentelemetry, traces_exporter: :none

# Tests poll the lobby with their own probes, never the network.
config :uro, :lobby_poller, false
config :uro, :lobby_basis_servers, []
