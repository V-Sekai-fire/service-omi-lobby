# Inventory

This repository began as a copy of the Uro zone backend. The lobby uses a small part of it. This page lists each part and whether the lobby needs it, so later changes can remove what it does not need.

Status words:

- **Lobby**: the lobby page needs this to work.
- ~~Struck through~~ **Unshipped**: removed.
- **Decide**: kept for now; someone must decide.

## Lobby

- `Uro.Interactor.Lobby`, `Uro.Transport.Poller`, `Uro.Datasource.Basis.Query`, `Uro.Datasource.Overte.Directory`, `Uro.Entities.Lobby.Server`: poll Basis servers and Overte domains every 10 minutes and hold the list in memory. **Lobby.**
- `GET /api/v1/lobby/servers` (`Uro.Transport.Web.Controllers.Lobby`), `/health`, `/api/v1/openapi`: the page reads the list here, and the front end builds its API client from the OpenAPI spec. **Lobby.**
- `frontend/` page `/` (`(static)/page.tsx`, `refresh-ring`, `section`, `footer`): the lobby page. **Lobby.**
- `fly/api`, `fly/web`: the Fly deploy of the API and the site. **Lobby.**
- `Uro.Repository.Repo` (SQLite) and `priv/repo/migrations`: the API starts the repo and runs migrations at boot. The lobby list itself writes nothing to it. **Lobby** while the account features below stay.

## Storage

- ~~sqlite-vfs-fdb: the `weft_fdb` SQLite VFS from datasource-store, which kept database pages in FoundationDB (`Uro.Repo.WeftFdb`, `URO_WEFTFDB_EXTENSION`, the FoundationDB steps in CI, the offline check and the Fly image)~~ **Unshipped.** The database is now a SQLite file; on Fly it is on a volume.
- ~~`aria_storage` and desync: the `/chunks` chunk server, the bake and manifest endpoints, and `.github/workflows/casync-interop.yml`, which checked `aria_storage` against desync~~ **Unshipped.**
- Shared files (`/api/v1/storage/*` list, show, upload, update, delete): the front-end `/download` page lists them by tag. **Decide**, with `/download`.
- Uploads (`waffle`, `/uploads`, `UPLOAD_STORAGE`): user icons and shared files. **Decide**, with shared files.

## Accounts and sign-in

Registration is closed on the public deploy, and the lobby page needs no account.

- Users, sessions, login, e-mail confirmation (`Uro.Interactor.Accounts`, `pow`, `pow_assent`, `Uro.Service.Mailer`): **Decide.** Server submission and moderation, which are parked, would need an admin sign-in.
- Second factor, passkeys, device grant (`Uro.Interactor.SecondFactor`, `Uro.Interactor.Passkeys`, `Uro.Interactor.DeviceGrant`): **Decide**, with accounts.
- Admin (`/api/v1/admin`, front-end `/admin`): **Decide**, with accounts.
- Cloudflare Turnstile (`Uro.Service.Turnstile`): **Decide**, with accounts.
- ~~Friends, identity proofs (`Uro.UserRelations`)~~ **Unshipped.** `Uro.Interactor.UserIdentities` (OAuth sign-in) stays with accounts.
- Front-end pages `/login`, `/sign-up`, `/confirm-email`, `/user/[userId]`, `/download`, `/about`, `/v-sekai`: **Decide**, with accounts. `/download` and `/v-sekai` are V-Sekai pages, not lobby pages.

## V-Sekai game services

None of these served the lobby; all are removed.

- ~~Zones (`/api/v1/shards`, `Uro.VSekai`, `Uro.VSekai.ZoneJanitor`): V-Sekai zone server registration~~ **Unshipped.**
- ~~Avatars, maps, props, backpacks (`Uro.UserContent`, `Uro.Inventory`, the `/dashboard` routes)~~ **Unshipped.**
- ~~Game loop (`apps/uro_loop`, `Uro.Loop`, `Uro.LoopCore`, `/api/v1/loop/commit`)~~ **Unshipped.**
- ~~Planner, ReBAC, HRR, tagging, the System (`Uro.Planner`, `Uro.ReBAC`, `Uro.HRR`, `Uro.Tagging`, `Uro.Gyre`, `priv/domains`, `priv/gyre`)~~ **Unshipped.**
- ~~Agents' work queue (`Uro.AgentTasks`, `Uro.AgentTasks.Janitor`)~~ **Unshipped.**
- ~~RISC-V sandbox NIF (`lib/weft_warp_burrito`, `c_src`, `Makefile`): the native build that needed CMake and Ninja~~ **Unshipped.**
- ~~Lockstep and float checks (`c_src/lockstep`, `c_src/host_test`)~~ **Unshipped.**
- ~~CASSIE Lean tree (`lean/`) and its pre-commit hooks~~ **Unshipped.**
- ~~`scripts/godot_uro_calls`, `multiplayer-fabric-generate-secrets`~~ **Unshipped.**

## Build, deploy and checks

- `.github/workflows/ci.yml`: compile, format, tests, Dialyzer. **Lobby.**
- `.github/workflows/offline.yml`, `tools/offline`: runs Uro and the VictoriaMetrics suite with no route out. **Decide.**
- OpenTelemetry export (`opentelemetry*`, `Uro.Telemetry`): **Decide.** It goes with the offline check.
- ~~`.github/workflows/build-image.yml`, root `Dockerfile`, `docker-compose.yml`, `Caddyfile`, Burrito release: the old zone backend's image and stack~~ **Unshipped.** The Fly deploy uses `fly/` instead.
- `docs/decisions`: decision records from the zone backend. **Decide.**
- ~~`AGENTS.md` sections on the zone backend's deploy, asset cycles and PoC runbook~~ **Unshipped.** The rest is agent guidance for this repo.
