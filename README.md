# service-omi-lobby

Uro, the lobby for V-Sekai — an Elixir/Phoenix API plus a Next.js site, served as one web application behind a single Caddy host.

## Use

The site is the front of the lobby: a V-Sekai landing page, the list of online zone servers (player counts, status, messages), and user accounts (signup, login, profile, downloads). It talks to the Uro API through `/api/v1/*` and `/uploads/*`.

Caddy (`Caddyfile`) serves both on one domain:

| Path | Backed by |
|------|----------|
| `/api/v1/*`, `/uploads/*` | the Uro API (`uro:4000`) |
| everything else            | the Next.js site (`nextjs:3000`) |

## Build and run

```sh
# Full local stack (CockroachDB, Redis, Uro, the site, Caddy)
cp .env.example .env
docker compose up
```

The site is served by Caddy at `http://vsekai.local`. Develop the site with `pnpm dev` from `frontend/`; run the Uro API with `mix deps.get && mix ecto.setup && mix phx.server` (needs CMake and Ninja, since the build compiles a native sandbox library). Deploy on Fly.io via the manifests in `fly/` (`fly/api` for the backend, `fly/web` for the site).

## See also

- [V-Sekai/uro](https://github.com/V-Sekai/uro) — the upstream Uro backend this split carries (custom content, caching, auth).
- [V-Sekai/flux-config](https://github.com/V-Sekai/flux-config) — deployment flux configurations for the V-Sekai backend.
- [V-Sekai-fire org](https://github.com/V-Sekai-fire) — companion org (e.g. `service-zone`, `service-game-observability`).

## Contributors

See [ALL-CONTRIBUTORS.md](ALL-CONTRIBUTORS.md) for the full list.

## Licence

MIT. See `LICENSE`.
