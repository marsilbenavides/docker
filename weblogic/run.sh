#!/bin/sh
WLS_IMAGE_NAME="oxxo-wls:15.1.1.0.0"
docker run --rm -it\
  ${WLS_IMAGE_NAME}\
  /bin/bash