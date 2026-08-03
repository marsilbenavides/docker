#!/bin/sh
# Enable strict mode
set -euo pipefail

# Ensure local config directories exist
echo "Preparing local directories..."
mkdir -p ~/motioneye/{config,videos}

docker run -dit \
  --name "motioneye" \
  -p 8765:8765 \
  -v /etc/localtime:/etc/localtime:ro \
  -v ~/motioneye/config:/etc/motioneye \
  -v ~/motioneye/videos:/var/lib/motioneye \
  "motioneye-img"
