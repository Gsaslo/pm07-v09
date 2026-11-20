#!/usr/bin/env bash
set -Eeuo pipefail
umask 077
WORK="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$WORK/config.env"
mkdir -p "$WORK/out" "$WORK/backups" "$WORK/logs"
LOG="$WORK/logs/run.log"
STAMP="$(date +%Y%m%d_%H%M%S)"
log() { printf '%s [%s] %s\n' "$(date -Is)" "$1" "$2" >> "$LOG"; }
trap 'rc=$?; log ERROR "exit=$rc"; exit "$rc"' ERR

export PGPASSFILE="$AUTH"
db_query() {
    "$CLIENT" -X -w -h "$DB_HOST" -p "$DB_PORT" -U admin -d "$DB" -v ON_ERROR_STOP=1 -A -t -c "$1"
}
dump_db() {
    "$DUMP" -w -h "$DB_HOST" -p "$DB_PORT" -U admin -d "$DB" -Fc -f "$1"
}

run_task() {
    count=$(db_query "SELECT COUNT(*) FROM bookings WHERE event_at >= timestamp '$CHECK_TIME' - interval '1 hour' AND event_at <= timestamp '$CHECK_TIME';")
    printf '%s count=%s\n' "$CHECK_TIME" "$count" >> "$WORK/out/fresh_bookings.log"
    log INFO "fresh_bookings=$count"
}

log INFO "START db=$DB"
started_ms="$(date +%s%3N)"
run_task
finished_ms="$(date +%s%3N)"
log INFO "elapsed_ms=$((finished_ms - started_ms))"
log INFO "END result=OK"
exit 0
