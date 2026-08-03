#!/bin/sh

# This image wast built using the online-documentation:
# https://handbrake.fr/docs/en/latest/developer/build-linux.html

# Build the binary
docker build\
  --file handbrake/Dockerfile.ollama\  
  --build-arg HANDBRAKE_GIT_URL=https://github.com/HandBrake/HandBrake.git\
  -t handbrake:latest\
  .

# Extract the ghb binary
docker cp $(docker create handbrake:latest):/tmp/handbrake/build/gtk/src/ghb ./
