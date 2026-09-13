# Dockerfile — tema testi.
# syntax=docker/dockerfile:1.7

ARG NODE_VERSION=22-alpine
ARG BUILD_DATE

# ---- Derleme aşaması ----
FROM node:${NODE_VERSION} AS builder

LABEL org.opencontainers.image.title="Yazılım Yolu Tema" \
      org.opencontainers.image.version="0.2.1" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      maintainer="yazilimyolu.example"

ENV NODE_ENV=production \
    TZ=Europe/Istanbul \
    PATH="/app/node_modules/.bin:${PATH}"

SHELL ["/bin/sh", "-eu", "-o", "pipefail", "-c"]

WORKDIR /app

COPY --chown=node:node package*.json ./
COPY --from=ghcr.io/yazilimyolu/tools:latest /usr/local/bin/vsce /usr/local/bin/vsce

RUN --mount=type=cache,target=/root/.npm \
    npm ci --omit=dev \
 && npm cache clean --force

ADD https://example.com/tema.tar.gz /tmp/tema.tar.gz

COPY . .

RUN set -eux; \
    if [ -f "themes/yazilim-yolu-dark-color-theme.json" ]; then \
      vsce package --out /app/dist/tema.vsix; \
    else \
      echo "tema dosyası yok" >&2; exit 1; \
    fi

# ---- Çalışma aşaması ----
FROM alpine:3.20 AS runtime

ARG UID=1000
ARG GID=1000

RUN addgroup -g "${GID}" -S app \
 && adduser -u "${UID}" -S -G app app \
 && apk add --no-cache ca-certificates tini

WORKDIR /srv

COPY --from=builder --chown=app:app /app/dist ./dist

VOLUME ["/srv/data", "/srv/cache"]

EXPOSE 8080/tcp 9090/udp

USER app:app

STOPSIGNAL SIGTERM

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD wget --spider -q http://localhost:8080/health || exit 1

ONBUILD COPY . /srv/ek

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["sh", "-c", "echo 'Yazılım Yolu v0.2.1' && sleep infinity"]
