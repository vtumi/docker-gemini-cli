ARG ALPINE_VERSION=3.22
FROM python:3.11-alpine${ALPINE_VERSION} AS builder

RUN \
  apk update && \
  apk add g++ make nodejs npm && \
  npm i -g @google/gemini-cli

FROM alpine:${ALPINE_VERSION}

ARG GEMINI_API_KEY

COPY --from=builder /usr/local/lib/node_modules/. /usr/local/lib/node_modules/

RUN \
  apk update && \
  apk add --no-cache nodejs npm tzdata && \
  ln -s /usr/local/lib/node_modules/@google/gemini-cli/dist/index.js /usr/local/bin/gemini

ENV GEMINI_API_KEY=${GEMINI_API_KEY}

WORKDIR /config

ENTRYPOINT ["gemini"]
