# SPDX-License-Identifier: MIT
# Copyright (c) 2026 K. S. Ernest (iFire) Lee
defmodule Uro do
  @moduledoc ~S"""
  Uro is the Phoenix API behind the OMI Lobby: it polls Basis servers and Overte domains
  every 10 minutes and serves the list at `GET /api/v1/lobby/servers`.

  ## Layout

  Uro uses the Netflix hexagonal layout. The seven sides use the same names as the
  V-Sekai-fire repos. Dependencies point inward: `transport -> interactor -> entities`. An
  interactor reaches the outside only through a `contract` behaviour, and `repository`,
  `datasource` and `service` modules answer those.

  | Directory | Namespace | Holds |
  | --- | --- | --- |
  | `lib/uro/transport` | `Uro.Transport` | `Web` (endpoint, router, controllers, plugs, helpers) and `Poller` |
  | `lib/uro/contract` | `Uro.Contract` | Behaviours `ServerProbe` and `ServerDirectory`, and `OpenAPI.Specification` |
  | `lib/uro/interactor` | `Uro.Interactor` | `Lobby`, `Accounts`, `Passkeys`, `SecondFactor`, `DeviceGrant`, `SharedContent`, `UserIdentities`, `Users` |
  | `lib/uro/entities` | `Uro.Entities` | Ecto schemas, `Lobby.Server`, `Support.*` |
  | `lib/uro/repository` | `Uro.Repository` | `Repo` (SQLite) |
  | `lib/uro/datasource` | `Uro.Datasource` | `Basis.Query` (UDP) and `Overte.Directory` (HTTP) |
  | `lib/uro/service` | `Uro.Service` | `Mailer`, `Turnstile`, `Tokens`, `Uploads`, `Telemetry`, Pow cache |

  Put new code in the layer it belongs to. `Uro.Inventory` lists what the lobby keeps and
  what was removed.

  ## Elixir requirements kept

  - Mix layout: `mix.exs` at the root, `lib/`, `config/`, `priv/`, `test/`; one module per
    file, and the path matches the module name.
  - The OTP application module stays at `lib/uro/application.ex` as the entry point.
  - Migrations stay in `priv/repo/migrations` with their `Uro.Repo.Migrations.*` names,
    because merged migrations never change. The repo sets `priv: "priv/repo"` so Ecto still
    finds them.
  - Tagged tuples at every boundary, and the SPDX header on every first-party file
    (`scripts/check_spdx.py`).

  ## Pragmatic choice

  Ecto schemas live in `entities`. Pow and Waffle tie them to Ecto, and splitting them would
  add mappers with no second repository to justify them. Only `Repo` sits in `repository`.
  """
end
