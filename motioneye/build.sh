#!/bin/sh
# Set strict error handling:
# -e: Exit on error
# -u: Error on unset variables
# -o pipefail: Pipeline return code depends on the last non-zero exit status
set -euo pipefail

# Configuration variables
MOTIONEYE_DIR="/tmp/motioneye_git/"
MOTIONEYE_IMAGE_NAME="motioneye-img"

# Step 1: Ensure source repository is available
if [ ! -d "$MOTIONEYE_DIR" ]; then
  echo "Cloning motionEye repository..."
  mkdir -p "$MOTIONEYE_DIR"
  git clone https://github.com/motioneye-project/motioneye.git "$MOTIONEYE_DIR"
  git switch main
fi

# Step 2: Sync with latest code and verify Dockerfile presence
if [ -f "$MOTIONEYE_DIR/docker/Dockerfile" ]; then
  echo "Updating motionEye repository..."
  cd "$MOTIONEYE_DIR"
  git switch main
  git pull
  cd -
else
  echo "Error: Dockerfile not found in the motionEye repository."
  exit 1
fi

# Final check for Dockerfile integrity before build
if [ ! -f "$MOTIONEYE_DIR/docker/Dockerfile" ]; then
  echo "Error: Dockerfile not found in the motionEye repository."
  exit 1
fi

# Step 3: Build the Docker image
# Use a subshell to isolate the directory change from the rest of the script
(
  echo "Building motionEye Docker image..."
  cd "$MOTIONEYE_DIR"
  docker build \
    --network host \
    --build-arg="RUN_UID=$(id -u ${RUN_USER:-$(whoami)})" \
    --build-arg="RUN_GID=$(id -g ${RUN_USER:-$(whoami)})" \
    --tag "$MOTIONEYE_IMAGE_NAME" \
    --file ./docker/Dockerfile .
)
