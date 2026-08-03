#! /bin/bash
docker stop "pihole"
docker rm "pihole"

mkdir -p ~/etc-pihole
mkdir -p ~/etc-dnsmasq.d
docker run -dit \
  --name "pihole" \
  -p 53:53 \
  -p 53:53/udp \
  -p 8888:80 \
  -v ~/etc-pihole:/etc/pihole \
  -v ~/etc-dnsmasq.d:/etc/dnsmasq.d \
  -e TZ="America/Monterrey" \
  -e WEBPASSWORD="*PiHole*01" \
  pihole/pihole
