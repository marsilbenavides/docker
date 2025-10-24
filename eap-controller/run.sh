#!/bin/sh
mkdir -p ~/omada/data
mkdir -p ~/omada/logs

docker stop "eap-controller"
docker rm "eap-controller"

docker run -dit\
  --name "eap-controller"\
  -p 8088:8088\
  -p 8043:8043\
  -p 8843:8843\
  -p 27001:27001\
  -p 29810:29810\
  -p 29811:29811\
  -p 29812:29812\
  -p 29813:29813\
  -p 29814:29814\
  -p 29815:29815\
  -p 29816:29816\
  -v ~/omada/data:/opt/tplink/EAPController/data\
  -v ~/omada/logs:/opt/tplink/EAPController/logs\
  "eap-controller-img"
