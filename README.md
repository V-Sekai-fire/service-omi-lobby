# service-omi-lobby

A lobby for the open metaverse: one page that lists servers you can join now, across platforms. The working name is OMI Lobby; the final name is still open.

## Purpose

OMI Lobby lists ready-to-join metaverse servers. We, the Open Metaverse Interoperability Group, hope this experiment makes spaces easier to find for everyone.

To list a server here, reach out to the group. The lobby can poll any space that has a server address, and it does so every 10 minutes.

For each server the lobby shows its name, whether it is up, players online and capacity, its address, and its message of the day. It lists Basis servers and Overte domains today, and other platforms can follow.

## How it works

- Uro, the Phoenix API in this repository, polls every listed server every 10 minutes. Basis servers are the addresses in the `:lobby_basis_servers` setting, each asked for its status directly. Overte domains come from the public Overte directory. `Uro.Lobby` describes the details.
- Uro holds the list in memory and replaces it whole on each poll, so the list adds nothing to the database. A domain that leaves the Overte directory drops off the list.
- The Next.js site in `frontend/` shows the list at `/` and counts down to the next poll. It reads the list from `GET /api/v1/lobby/servers` on the server side, so a browser never calls the API.

## Build and run

Run Uro with its development database in a local file:

```sh
mix deps.get && mix ecto.setup && mix phx.server
```

The build compiles a native sandbox library, so CMake and Ninja must be on the path. Run the site with `pnpm install && pnpm dev` in `frontend/`. The `docker-compose.yml` stack does not match the current database and is not a supported way to run Uro.

`fly/` holds the Fly.io deploy: `fly/api` for Uro, with no public address, and `fly/web` for the site.

## Licence

MIT. See `LICENSE`.
