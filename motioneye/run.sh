#!/bin/sh
# Enable strict mode
set -euo pipefail

MOTIONEYE_IMAGE_NAME="motioneye-img"
MOTIONEYE_CONTAINER_NAME="motioneye"

# Ensure local config directories exist
echo "Preparing local directories..."
mkdir -p ~/motioneye/{config,videos}

# Stop and remove any existing motionEye container
if [ "$(docker ps -q -f name=$MOTIONEYE_CONTAINER_NAME)" ]; then
  echo "Stopping existing $MOTIONEYE_CONTAINER_NAME container..."
  docker stop "$MOTIONEYE_CONTAINER_NAME"
  docker rm "$MOTIONEYE_CONTAINER_NAME"
fi

docker run -dit \
  --name "$MOTIONEYE_CONTAINER_NAME"\
  --publish 8765:8765\
  --volume /etc/localtime:/etc/localtime:ro\
  --volume ~/motioneye/config:/etc/motioneye\
  --volume ~/motioneye/videos:/var/lib/motioneye\
  "$MOTIONEYE_IMAGE_NAME"
