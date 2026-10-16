#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# Uro's sandbox on the private network: the WAN must be unreachable, and Uro writes its database
# only to its own directory. Its spans, its log and the run's measurements land in the
# VictoriaMetrics suite at 10.77.0.3.
set -euo pipefail
work=$1
db="$work/uro/uro_offline.db"
obs=http://10.77.0.3

# Polls a suite query until its answer passes [ answer <op> <want> ]; prints the last answer either way.
# Traces become searchable only after VictoriaTraces' 30 s latency offset, hence the 90 s window.
await() {
  local op=$1 want=$2 got=""
  shift 2
  for _ in $(seq 90); do
    got=$("$@" || true)
    [ -n "$got" ] && [ "$got" "$op" "$want" ] 2> /dev/null && break
    sleep 1
  done
  echo "$got"
}
hits() { curl -sf "$obs:$1/select/logsql/query" --data-urlencode "query=_time:1h $2 | stats count() n" | jq -r .n; }
sample() { curl -sf "$obs:8428/api/v1/export" --data-urlencode "match[]=$1" | jq -r '.values[-1]'; }
ship() {
  jq -Rc --arg s "$1" 'select(length > 0) | {stream: $s, msg: .}' < "$2" |
    curl -sf -X POST -H 'Content-Type: application/stream+json' --data-binary @- \
      "$obs:9428/insert/jsonline?_stream_fields=stream&_msg_field=msg"
}

if curl -sS --max-time 5 -o /dev/null https://github.com 2> /tmp/wan.txt; then
  echo "FAIL: github.com answered on the private network"
  exit 1
fi
echo "control: the WAN is unreachable ($(tr -d '\n' < /tmp/wan.txt))"

for port in 8428 9428 10428; do
  if [ "$(await = OK curl -sf "$obs:$port/health")" != OK ]; then
    echo "FAIL: the suite's store on $obs:$port never answered"
    exit 1
  fi
done
export OTEL_TRACES_EXPORTER=otlp OTEL_EXPORTER_OTLP_ENDPOINT=$obs:10428/insert/opentelemetry \
  OTEL_SERVICE_NAME=uro-offline OTEL_BSP_SCHEDULE_DELAY_MILLIS=1000

# Control, run first so that by the time Uro's spans are searchable any of its own would be too: an
# exporter pointed at a closed port must log failed connects and store no spans.
cat > "$work/control.exs" <<'ELIXIR'
{:ok, _} = Application.ensure_all_started(:opentelemetry_exporter)
{:ok, _} = Application.ensure_all_started(:opentelemetry)
require OpenTelemetry.Tracer
OpenTelemetry.Tracer.with_span "offline-control", do: :ok
Process.sleep(3_000)
ELIXIR
OTEL_SERVICE_NAME=uro-offline-control OTEL_EXPORTER_OTLP_ENDPOINT=$obs:1/insert/opentelemetry \
  mix run --no-start "$work/control.exs" > "$work/control.log" 2>&1

export TEST_DATABASE="$db"
mix ecto.migrate
mix run priv/repo/test_seeds.exs
URO_SUITE_URL=$obs mix test --include suite 2>&1 | tee "$work/uro-test.log"

bytes=$(stat -c %s "$db" 2> /dev/null || echo 0)
echo "bytes Uro wrote to its SQLite file: $bytes"
[ "$bytes" -gt 0 ]

lines=$(grep -c . "$work/uro-test.log")
ship uro-offline-test "$work/uro-test.log"
ship uro-offline-control "$work/control.log"
printf 'uro_offline_db_bytes %s\nuro_offline_log_lines %s\n' "$bytes" "$lines" |
  curl -sf -X POST -H 'Content-Type: text/plain' --data-binary @- "$obs:8428/api/v1/import/prometheus"
spans=$(await -gt 0 hits 10428 '"resource_attr:service.name":="uro-offline" name:*')
stored=$(await = "$lines" hits 9428 'stream:"uro-offline-test"')
connects=$(hits 9428 'stream:"uro-offline-test" failed_connect')
metric=$(await = "$bytes" sample uro_offline_db_bytes)
control_connects=$(await -gt 0 hits 9428 'stream:"uro-offline-control" failed_connect')
control_spans=$(hits 10428 '"resource_attr:service.name":="uro-offline-control" name:*')
echo "suite: $spans spans from Uro, $stored of $lines log lines, $connects failed connects, bytes metric $metric"
echo "control: $control_connects failed connects and $control_spans spans from an exporter with no collector"
if ! { [ "$spans" -gt 0 ] && [ "$stored" = "$lines" ] && [ "$connects" = 0 ] && [ "$metric" = "$bytes" ]; }; then
  echo "FAIL: the suite did not receive the run as sent"
  exit 1
fi
if ! { [ "$control_connects" -gt 0 ] && [ "$control_spans" = 0 ]; }; then
  echo "FAIL: the control's failed exports went unseen"
  exit 1
fi

