# Architecture

Uro uses the Netflix hexagonal layout. The seven sides use the same names as the V-Sekai-fire repos. Dependencies point inward: `transport -> interactor -> entities`. An interactor reaches the outside only through a `contract` behaviour, and `repository`, `datasource` and `service` modules answer those.

| Directory | Namespace | Holds |
| --- | --- | --- |
| `lib/uro/transport` | `Uro.Transport` | `Web` (endpoint, router, controllers, plugs, helpers) and `Poller` |
| `lib/uro/contract` | `Uro.Contract` | Behaviours `ServerProbe` and `ServerDirectory`, and `OpenAPI.Specification` |
| `lib/uro/interactor` | `Uro.Interactor` | `Lobby`, `Accounts`, `Passkeys`, `SecondFactor`, `DeviceGrant`, `SharedContent`, `UserIdentities`, `Users` |
| `lib/uro/entities` | `Uro.Entities` | Ecto schemas, `Lobby.Server`, `Support.*` |
| `lib/uro/repository` | `Uro.Repository` | `Repo` (SQLite) |
| `lib/uro/datasource` | `Uro.Datasource` | `Basis.Query` (UDP) and `Overte.Directory` (HTTP) |
| `lib/uro/service` | `Uro.Service` | `Mailer`, `Turnstile`, `Tokens`, `Uploads`, `Telemetry`, `Pow` |

## Elixir requirements kept

- Mix layout: `mix.exs` at the root, `lib/`, `config/`, `priv/`, `test/`; one module per file, and the path matches the module name.
- `Uro.Application` stays at `lib/uro/application.ex` as the OTP entry point.
- Migrations stay in `priv/repo/migrations` with their `Uro.Repo.Migrations.*` names, because merged migrations never change. The repo sets `priv: "priv/repo"` so Ecto still finds them.
- Tagged tuples at every boundary, and the SPDX header on every first-party file (`scripts/check_spdx.py`).

## Swapping a datasource

The lobby interactor reads its probe and directory from config, so a test or another platform can bring its own:

```elixir
config :uro, :lobby_server_probe, MyApp.FakeProbe
config :uro, :lobby_server_directory, MyApp.FakeDirectory
```

## Pragmatic choice

Ecto schemas live in `entities`. Pow and Waffle tie them to Ecto, and splitting them would add mappers with no second repository to justify them. Only `Repo` sits in `repository`.
