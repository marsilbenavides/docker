#!/bin/sh
docker pull ghcr.io/nesquena/hermes-webui:latest
docker run -d\
  --name hermes_webui\
  --env WANTED_UID=$(id -u)\
  --env WANTED_GID=$(id -g)\
  --env HERMES_WEBUI_STATE_DIR=/home/hermeswebui/.hermes/webui\
  --volume ~/.hermes:/home/hermeswebui/.hermes\
  --volume ~/workspace:/workspace\
  --publish 8787:8787\
  --restart always\
  ghcr.io/nesquena/hermes-webui:latest