#! /bin/bash

# Create local directories
SQUID_CONTAINER_NAME="squid"
SQUID_PORT=3128

# Stop and remove any existing motionEye container
if [ "$(docker ps -qa -f name=$SQUID_CONTAINER_NAME)" ]; then
  echo "Stopping existing $SQUID_CONTAINER_NAME container..."
  docker stop "$SQUID_CONTAINER_NAME"
  docker rm "$SQUID_CONTAINER_NAME"
fi

echo "Downloading latest squid image..."
docker pull ubuntu/squid:latest

echo "Running squid..."
docker run -dit\
  --name ${SQUID_CONTAINER_NAME}\
  --restart always\
  --env "TZ=America/Monterrey"\
  --publish $SQUID_PORT:$SQUID_PORT\
  ubuntu/squid:latest
