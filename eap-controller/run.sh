#!/bin/sh
mkdir -p ~/omada/data
mkdir -p ~/omada/logs

docker stop "eap-controller"
docker rm "eap-controller"

docker run -dit\
  --name "eap-controller"\
  --cap-add ALL\
  -p 8088:8088\
  -p 8043:8043\
  -p 8843:8843\
  -p 27001:27001/udp\
  -p 29810:29810/udp\
  -p 29811:29811\
  -v ~/omada/data:/opt/tplink/EAPController/data\
  -v ~/omada/logs:/opt/tplink/EAPController/logs\
  "eap-controller-img"


#  -p 8088:8088\
#  -p 8043:8043\
#  -p 8843:8843\
#  -p 27001:27001/udp\
#  -p 29810:29810/udp\
#  -p 29811:29811\
#  -v ~/omada/data:/opt/tplink/EAPController/data\
#  -v ~/omada/logs:/opt/tplink/EAPController/logs\