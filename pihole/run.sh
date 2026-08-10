#! /bin/bash
docker stop "pihole"
docker rm "pihole"

mkdir -p ~/etc-pihole
mkdir -p ~/etc-dnsmasq.d
docker run -dit \
  --name "pihole" \
  --restart always\
  --publish 53:53 \
  --publish 53:53/udp \
  --publish 8888:80 \
  --volume ~/etc-pihole:/etc/pihole \
  --volume ~/etc-dnsmasq.d:/etc/dnsmasq.d \
  --env TZ="America/Monterrey" \
  --env WEBPASSWORD="*PiHole*01" \
  pihole/pihole
