#!/bin/sh
# Railway wrapper for Grimoire: daemon on loopback only, Caddy basic-auth proxy on $PROXY_PORT.
set -eu
if [ -z "${GRIMOIRE_PASSWORD:-}" ]; then echo "[railway] GRIMOIRE_PASSWORD is not set; refusing to start without auth" >&2; exit 1; fi
mkdir -p /data/config /data/caddy-data
GRIMOIRE_PASSWORD_HASH=$(caddy hash-password --plaintext "$GRIMOIRE_PASSWORD")
export GRIMOIRE_PASSWORD_HASH
unset GRIMOIRE_PASSWORD
cd /app
HOST=127.0.0.1 bun run daemon:start &
APP=$!
caddy run --config /etc/railway/Caddyfile --adapter caddyfile &
PROXY=$!
trap 'kill $APP $PROXY 2>/dev/null' TERM INT
# exit (so Railway restarts the container) as soon as either process stops
while kill -0 $APP 2>/dev/null && kill -0 $PROXY 2>/dev/null; do sleep 2; done
echo "[railway] a process exited; stopping" >&2
kill $APP $PROXY 2>/dev/null || true
wait || true
exit 1
