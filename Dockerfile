ARG ALPINE_VERSION=3.22
FROM python:3.11-alpine${ALPINE_VERSION} AS builder

RUN \
  apk update && \
  apk add g++ make nodejs npm && \
  npm i -g @google/gemini-cli

FROM alpine:${ALPINE_VERSION}

ARG USER=default
ARG GEMINI_API_KEY

ENV HOME /config
ENV GEMINI_API_KEY=${GEMINI_API_KEY}

COPY --from=builder /usr/local/lib/node_modules/. /usr/local/lib/node_modules/

RUN \
  apk update && \
  apk add --no-cache curl nodejs npm sudo tzdata && \
  ln -s /usr/local/lib/node_modules/@google/gemini-cli/dist/index.js /usr/local/bin/gemini

RUN adduser -D $USER && \
  mkdir -p /etc/sudoers.d && \
  echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER && \
  chmod 0440 /etc/sudoers.d/$USER

USER $USER
WORKDIR $HOME

CMD ["tail", "-f", "/dev/null"]
