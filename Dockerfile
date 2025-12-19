FROM node:20-alpine3.22

ARG GEMINI_API_KEY

# Install packages
RUN apk add --no-cache tzdata

RUN npm install -g @google/gemini-cli

ENV GEMINI_API_KEY=${GEMINI_API_KEY}

WORKDIR /config

ENTRYPOINT ["gemini"]
