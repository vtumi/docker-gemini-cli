FROM node:20-slim

ARG GEMINI_API_KEY

RUN npm install -g @google/gemini-cli

ENV GEMINI_API_KEY=${GEMINI_API_KEY}

WORKDIR /config

ENTRYPOINT ["gemini"]
