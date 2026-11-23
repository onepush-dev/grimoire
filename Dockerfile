# Grimoire on Railway: the official goniszewski/grimoire:1.4.0 image (MIT), application unmodified.
# Upstream: "Public-network exposure is not a supported mode; put an authenticated reverse proxy in front."
# Railway layer: Grimoire stays bound to 127.0.0.1:3210 inside the container (never reachable from outside),
# and Caddy (official caddy:2.11.9 binary) is the only listener, on 8080, with HTTP basic auth on every route
# except the /health probe. Runs as root so the root-owned Railway volume at /data is writable.
FROM caddy:2.11.9-alpine AS caddy
FROM goniszewski/grimoire:1.4.0
LABEL org.opencontainers.image.source="https://github.com/onepush-dev/grimoire"
USER root
COPY --from=caddy /usr/bin/caddy /usr/local/bin/caddy
COPY railway/Caddyfile /etc/railway/Caddyfile
COPY railway/start.sh /railway-start.sh
RUN chmod +x /railway-start.sh
ENV HOST=127.0.0.1 \
    PORT=3210 \
    DATA_DIR=/data \
    XDG_CONFIG_HOME=/data/config \
    HOME=/data \
    NODE_ENV=production \
    LOG_FORMAT=json \
    LITTLEIMP_IN_CONTAINER=1 \
    PROXY_PORT=8080 \
    GRIMOIRE_USERNAME=admin \
    XDG_DATA_HOME=/data/caddy-data
EXPOSE 8080
HEALTHCHECK NONE
ENTRYPOINT []
CMD ["/railway-start.sh"]
