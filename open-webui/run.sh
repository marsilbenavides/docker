#!/bin/sh
# Enable strict mode
set -euo pipefail

# Ensure local config directories exist
echo "Preparing local directories..."
mkdir -p ~/open-webui/backend/data

docker stop open-webui
docker rm open-webui
docker run -dit\
  --publish 3000:8080\
  --env OLLAMA_BASE_URL=http://192.168.1.149:11434/\
  --volume ~/open-webui/backend/data:/app/backend/data\
  --name open-webui\
  --restart always\
  ghcr.io/open-webui/open-webui:main
