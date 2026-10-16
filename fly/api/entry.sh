set -eu
mkdir -p /app/priv/uploads "$(dirname "$URO_DATABASE")"
mix ecto.migrate
exec mix phx.server
