#!/bin/sh
# Enable strict mode
set -euo pipefail

MOTIONEYE_DIR="/tmp/motioneye_git/"
MOTIONEYE_IMAGE_NAME="motioneye-img"

if [ ! -d "$MOTIONEYE_DIR" ]; then
  echo "Cloning motionEye repository..."
  mkdir -p "$MOTIONEYE_DIR"
  git clone https://github.com/motioneye-project/motioneye.git "$MOTIONEYE_DIR"
  git switch main
fi

if [ -f "$MOTIONEYE_DIR/docker/Dockerfile" ]; then
  # Refresh the git repository to ensure we have the latest version
  echo "Updating motionEye repository..."
  cd "$MOTIONEYE_DIR"
  git switch main
  git pull
  cd -
else
  echo "Dockerfile not found in the motionEye repository."
  exit 1
fi

if [ ! -f "$MOTIONEYE_DIR/docker/Dockerfile" ]; then
  echo "Dockerfile not found in the motionEye repository."
  exit 1
fi

# Build the Docker image for motionEye
# Use a subshell to keep the current directory unchanged during build
(
  echo "Building motionEye Docker image..."
  cd "$MOTIONEYE_DIR"
  docker build\
    --network host\
    --build-arg="RUN_UID=$(id -u ${RUN_USER:-$(whoami)})"\
    --build-arg="RUN_GID=$(id -g ${RUN_USER:-$(whoami)})"\
    --tag "$MOTIONEYE_IMAGE_NAME"\
    --file ./docker/Dockerfile .
)
