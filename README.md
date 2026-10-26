# service-omi-lobby (tentative name)

**(..) is a Server Browser to find Spaces on the Open Metaverse**

(..) lists ready-to-join servers. We, the Open Metaverse Interoperability Group, hope this experiment makes spaces easier to find for everyone.

This website polls available server IPs for their names, whether it is up, players online and capacity, its address, and its message of the day.
It lists Basis servers and Overte domains currently, aiming to expand to anything that allows to be self-hosted on individual servers. Through this, discovery of such independent projects can happen without a platform facilitating it.

To list a server here, simply submit a PR (see Adding new Servers below) or submit it through this form (link to be added). The lobby can poll any space that has a server address, and it does so every 10 minutes.

## Adding new Servers

To add Basis Servers make a PR adding a new line to /config/config.exs below 21 with your server ip. Or submit through our form (link to be added)
Overte Servers are polled from its public directory, please reach out if you wish to list one independent from that.

## How it works

**Uro polls every listed server every 10 minutes, and the site shows the list.**

- Uro, the Phoenix API in this repository, polls every listed server every 10 minutes.
Specifically:
Basis servers are the addresses in the `:lobby_basis_servers` setting, each asked for its status directly.
Overte domains come from the public Overte directory. Requiring no manual listing.
- Uro holds the list in memory and replaces it whole on each poll, so the list adds nothing to the database. A domain that leaves the Overte directory drops off the list.
- The Next.js site in `frontend/` shows the list at `/` and counts down to the next poll. It reads the list from `GET /api/v1/lobby/servers` on the server side, so a browser never calls the API. This means visitors to the site will never poll any listed server directly.

To run it yourself, please follow the Build and Run section below.

## Companion tray app

The Companion tray allows to browse this server list from your desktop without requiring to open the webpage.

[interactor-omi-lobby-tray](https://github.com/V-Sekai-fire/interactor-omi-lobby-tray) puts the lobby in the Windows taskbar. Its tray icon reads `GET /api/v1/lobby/servers` every 10 minutes and lists Basis and Overte Servers that are up. Picking a Basis server copies its address to paste into a Client built with Basis to join, picking an Overte address opens it in Overte through `hifi://` to join via Overte directly.

The tray app can be found in interactor-omi-lobby-tray to try it.

## Build and Run

Run Uro with its development database in a local file:

```sh
mix deps.get && mix ecto.setup && mix phx.server
```

Run the site with `pnpm install && pnpm dev` in `frontend/`.

`fly/` holds the Fly.io deploy: `fly/api` for Uro, with no public address, fly/web` holds the site.

Run both, then open the website.

## Contributors

**Uro began as a copy of V-Sekai/uro.**

`git log` here shows only later work. These people wrote Uro and its web front end before the copy ([V-Sekai/uro](https://github.com/V-Sekai/uro)):

- [SaracenOne](https://github.com/SaracenOne)
- [fire](https://github.com/fire)
- [lyuma](https://github.com/lyuma)
- [ariesclark](https://github.com/ariesclark)
- [benbot](https://github.com/benbot)
- [dragonhunt02](https://github.com/dragonhunt02)

Dependabot also committed upstream. Work in this repository: [fire](https://github.com/fire). The lobby is an experiment of the [Open Metaverse Interoperability Group](https://omigroup.org/). The lobby page lists the same people; `Uro.Contributors` in `mix docs` says how to update both.

## Licence

MIT. See `LICENSE`.
