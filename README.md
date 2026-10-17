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

## Companion tray app

[interactor-omi-lobby-tray](https://github.com/V-Sekai-fire/interactor-omi-lobby-tray) puts the lobby in the Windows taskbar. Its tray icon reads `GET /api/v1/lobby/servers` every 10 minutes and lists the Overte domains and Basis servers that are up, with players online. Picking an Overte domain opens it in Overte through `hifi://`; picking a Basis server copies its address to paste into Basis.

The tray calls the API from the player's machine, so it needs a lobby whose `/api/v1` is public, as the Mac staging lobby's is. The Fly deploy keeps the API private, so the tray cannot read it until the site serves the list on a public route.

## Build and run

Run Uro with its development database in a local file:

```sh
mix deps.get && mix ecto.setup && mix phx.server
```

Run the site with `pnpm install && pnpm dev` in `frontend/`.

`fly/` holds the Fly.io deploy: `fly/api` for Uro, with no public address, and `fly/web` for the site.

## Licence

MIT. See `LICENSE`.
