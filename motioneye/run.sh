#!/bin/sh
# Set strict error handling:
# -e: Exit on error
# -u: Error on unset variables
# -o pipefail: Pipeline return code depends on the last non-zero exit status
set -euo pipefail

# Configuration variables for image and container naming
MOTIONEYE_IMAGE_NAME="motioneye-img"
MOTIONEYE_CONTAINER_NAME="motioneye"

# Step 1: Environment Preparation
# Ensure persistent configuration and video storage directories exist.
echo "Preparing local directories..."
mkdir -p ~/motioneye/{config,videos}

# Step 2: Container Cleanup
# Check for any existing container named 'motioneye'. 
# Stop and remove it to ensure a clean deployment.
if [ "$(docker ps -qa -f name=$MOTIONEYE_CONTAINER_NAME)" ]; then
  echo "Stopping and removing existing $MOTIONEYE_CONTAINER_NAME container..."
  docker stop "$MOTIONEYE_CONTAINER_NAME"
  docker rm "$MOTIONEYE_CONTAINER_NAME"
fi

# Step 3: Deployment
# Run the motionEye container in detached mode (-d) with interactive terminal (-i) and TTY (-t).
# - --name: Static name for container identification.
# - --publish: Map host port 8765 to container port 8765 (web UI).
# - --volume /etc/localtime: Sync host time to the container (read-only).
# - --volume ~/motioneye/config: Mount configuration files for persistence.
# - --volume ~/motioneye/videos: Mount video storage for persistence.
# - --restart always: Ensure automatic restart on failure or system reboot.
docker run -dit \
  --name "$MOTIONEYE_CONTAINER_NAME" \
  --publish 8765:8765 \
  --volume /etc/localtime:/etc/localtime:ro \
  --volume ~/motioneye/config:/etc/motioneye \
  --volume ~/motioneye/videos:/var/lib/motioneye \
  --restart always \
  "$MOTIONEYE_IMAGE_NAME"
