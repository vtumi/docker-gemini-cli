ARG ALPINE_VERSION=3.22
FROM python:3.11-alpine${ALPINE_VERSION} AS builder

RUN set -x \
  && apk update \
  && apk add nodejs npm \
  && npm i -g @google/gemini-cli

FROM alpine:${ALPINE_VERSION}

ARG GEMINI_API_KEY

COPY --from=builder /usr/local/lib/node_modules/. /usr/local/lib/node_modules/
COPY --from=builder /usr/local/bin/gemini /usr/local/bin/

# Install packages
RUN apk add --no-cache tzdata nodejs npm

ENV GEMINI_API_KEY=${GEMINI_API_KEY}

WORKDIR /config

ENTRYPOINT ["gemini"]
