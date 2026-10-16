# Inventory

This repository began as a copy of the Uro zone backend. The lobby uses a small part of it. This page lists each part and whether the lobby needs it, so later changes can remove what it does not need.

Status words:

- **Lobby**: the lobby page needs this to work.
- **Unshipped**: removed.
- **Candidate**: the lobby does not use it. Remove it in a later change unless someone needs it.
- **Decide**: kept for now; someone must decide.

## Lobby

- `Uro.Lobby`, `Uro.Lobby.Poller`, `Uro.Lobby.BasisQuery`, `Uro.Lobby.OverteDirectory`, `Uro.Lobby.Server`: poll Basis servers and Overte domains every 10 minutes and hold the list in memory. **Lobby.**
- `GET /api/v1/lobby/servers` (`Uro.LobbyController`), `/health`, `/api/v1/openapi`: the page reads the list here, and the front end builds its API client from the OpenAPI spec. **Lobby.**
- `frontend/` page `/` (`(static)/page.tsx`, `refresh-ring`, `section`, `footer`): the lobby page. **Lobby.**
- `fly/api`, `fly/web`: the Fly deploy of the API and the site. **Lobby.**
- `Uro.Repo` (SQLite) and `priv/repo/migrations`: the API starts the repo and runs migrations at boot. The lobby list itself writes nothing to it. **Lobby** while the account features below stay.

## Storage

- sqlite-vfs-fdb: the `weft_fdb` SQLite VFS from datasource-store, which kept database pages in FoundationDB (`Uro.Repo.WeftFdb`, `URO_WEFTFDB_EXTENSION`, the FoundationDB steps in CI, the offline check and the Fly image). **Unshipped.** The database is now a SQLite file; on Fly it is on a volume.
- `aria_storage` chunk server (`/chunks`), `/api/v1/storage/*` and asset baking: casync chunk storage for uploaded assets. **Candidate.**
- `.github/workflows/casync-interop.yml`: checks `aria_storage` against desync. Goes with `aria_storage`. **Candidate.**
- Uploads (`waffle`, `/uploads`, `UPLOAD_STORAGE`): avatar, map and prop files. **Candidate.**

## Accounts and sign-in

Registration is closed on the public deploy, and the lobby page needs no account.

- Users, sessions, login, e-mail confirmation (`Uro.Accounts`, `pow`, `pow_assent`, `Uro.Mailer`): **Decide.** Server submission and moderation, which are parked, would need an admin sign-in.
- Second factor, passkeys, device grant (`Uro.SecondFactor`, `Uro.Passkeys`, `Uro.DeviceGrant`): **Decide**, with accounts.
- Admin (`/api/v1/admin`, front-end `/admin`): **Decide**, with accounts.
- Cloudflare Turnstile (`Uro.Turnstile`): **Decide**, with accounts.
- Friends, identity proofs (`Uro.UserRelations`, `Uro.UserIdentities`): **Candidate.**
- Front-end pages `/login`, `/sign-up`, `/confirm-email`, `/user/[userId]`, `/download`, `/about`, `/v-sekai`: **Decide**, with accounts. `/download` and `/v-sekai` are V-Sekai pages, not lobby pages.

## V-Sekai game services

None of these serve the lobby.

- Zones (`/api/v1/shards`, `Uro.VSekai`, `Uro.VSekai.ZoneJanitor`): V-Sekai zone server registration. **Candidate.**
- Avatars, maps, props, backpacks (`Uro.UserContent`, `Uro.SharedContent`, `Uro.Inventory`, the `/dashboard` routes): **Candidate.**
- Game loop (`apps/uro_loop`, `Uro.Loop`, `Uro.LoopCore`, `/api/v1/loop/commit`): **Candidate.**
- Planner, ReBAC, HRR, tagging, the System (`Uro.Planner`, `Uro.ReBAC`, `Uro.HRR`, `Uro.Tagging`, `Uro.Gyre`, `priv/domains`, `priv/gyre`): **Candidate.**
- Agents' work queue (`Uro.AgentTasks`, `Uro.AgentTasks.Janitor`): **Candidate.**
- RISC-V sandbox NIF (`lib/weft_warp_burrito`, `c_src/nif`, `c_src/thirdparty`, `Makefile`): the native build that makes CMake and Ninja necessary. **Candidate.**
- Lockstep and float checks (`c_src/lockstep`, `c_src/host_test`): **Candidate.**
- CASSIE Lean tree (`lean/`) and its pre-commit hooks: **Candidate.**
- `scripts/godot_uro_calls`, `multiplayer-fabric-generate-secrets`: **Candidate.**

## Build, deploy and checks

- `.github/workflows/ci.yml`: compile, format, tests, Dialyzer. **Lobby.**
- `.github/workflows/offline.yml`, `tools/offline`: runs Uro and the VictoriaMetrics suite with no route out. **Decide.**
- OpenTelemetry export (`opentelemetry*`, `Uro.Telemetry`): **Decide.** It goes with the offline check.
- `.github/workflows/build-image.yml`, root `Dockerfile`, `docker-compose.yml`, `Caddyfile`, Burrito release: the old zone backend's image and stack. The Fly deploy uses `fly/` instead. **Candidate.**
- `docs/decisions`: decision records from the zone backend. **Decide.**
- `AGENTS.md`: describes the zone backend's deploy, not this one. **Decide.**
