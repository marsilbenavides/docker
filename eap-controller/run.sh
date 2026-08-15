#!/bin/sh
EAP_CONTROLLER_VERSION="6.2.14.11"
mkdir -p ~/omada/data
mkdir -p ~/omada/logs

docker stop "eap-controller"
docker rm "eap-controller"

docker run -dit\
  --name "eap-controller"\
  --network host\
  --volume ~/omada/data:/opt/tplink/EAPController/data\
  --volume ~/omada/logs:/opt/tplink/EAPController/logs\
  "eap-controller-img:${EAP_CONTROLLER_VERSION}"
