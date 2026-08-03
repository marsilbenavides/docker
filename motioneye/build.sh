#!/bin/sh
MOTIONEYE_DIR="/tmp/motioneye_git/"

if [ ! -d $MOTIONEYE_DIR ]; then
  echo "Cloning motionEye repository..."
  mkdir -p $MOTIONEYE_DIR
  git clone https://github.com/motioneye-project/motioneye.git $MOTIONEYE_DIR
  git switch main
fi

if [ -f $MOTIONEYE_DIR/docker/Dockerfile ]; then
  # Refresh the git repository to ensure we have the latest version
  echo "Updating motionEye repository..."
  cd $MOTIONEYE_DIR
  git switch main
  git pull
  cd -
else
  echo "Dockerfile not found in the motionEye repository."
  exit 1
fi

if [ ! -f $MOTIONEYE_DIR/docker/Dockerfile ]; then
  echo "Dockerfile not found in the motionEye repository."
  exit 1
fi

# Everything is set up, now we can build and run the Docker container
echo "Starting motionEye Docker container..."

mkdir -p ~/motioneye
mkdir -p ~/motioneye/config
mkdir -p ~/motioneye/videos

(
  cd $MOTIONEYE_DIR
  docker build \
    --no-cache \
    --network host \
    --build-arg="RUN_UID=$(id -u ${RUN_USER})" \
    --build-arg="RUN_GID=$(id -g ${RUN_USER})" \
    -t "motioneye-img" \
    -f ./docker/Dockerfile .
)
