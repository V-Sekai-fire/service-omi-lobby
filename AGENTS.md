# AGENTS.md — service-omi-lobby

Uro, the Phoenix API behind the lobby, plus the Next.js site in `frontend/`. `README.md` says what the lobby is for; `docs/inventory.md` lists what is kept and what was removed.

## Deploy

`fly/api` (Uro, private) and `fly/web` (the site, public) hold the Fly.io configuration. The operator runs Fly deploys; agents do not run the `fly` CLI.

## Commit message style

Sentence case, imperative verb, no Conventional Commits prefix, under 72 characters.

## Test commands

```sh
mix test                           # unit tests
mix test --include suite           # also the telemetry suite (needs the VictoriaMetrics suite; see tools/offline)
mix credo --min-priority high      # linting
mix format --check-formatted       # formatting
```

## Red-green-refactor

1. **RED** — write a failing test with a specific, load-bearing error message.
   Briefly break the assertion to confirm the failure is not vacuous.
2. **GREEN** — write the minimum code to pass the test. No extra abstractions.
3. **REFACTOR** — clean up with tests still green. One commit per cycle.

The TDD arc must be legible in `git log`.

## Elixir conventions

- Functions return `{:ok, value}` / `{:error, reason}` at every boundary.
  `raise` is for programmer errors (wrong type, missing config at boot),
  never for runtime conditions.
- Migrations are forward-only. Once merged to main, never alter a migration.
  Every migration must include a `down/0`. Generate with
  `mix ecto.gen.migration <name>`, then add the SPDX header by hand.

## SPDX requirement

Every new first-party `.ex` or `.exs` file must contain both of these lines
in the first 2 KB:

```elixir
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 K. S. Ernest (iFire) Lee
```

`scripts/check_spdx.py` enforces this through the pre-commit hook.
