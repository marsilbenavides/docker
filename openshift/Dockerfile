FROM redhat/ubi8 AS build
COPY ./bin/crc-linux-amd64.tar.xz /opt/crc-linux-amd64.tar.xz
WORKDIR /opt
RUN dnf install tar xz -y && \
  tar -xf crc-linux-amd64.tar.xz &&\
  rm -rf crc-linux-amd64.tar.xz &&\
  groupadd --gid 2048 rh &&\
  useradd --gid 2048 -ms /bin/bash os &&\
  chown os:rh -R ./crc-linux-2.52.0-amd64

FROM redhat/ubi8 AS main
COPY --from=build /opt /opt
WORKDIR /opt/crc-linux-2.52.0-amd64
RUN dnf install sudo kmod -y && \
  groupadd --gid 2048 rh &&\
  useradd --gid 2048 -ms /bin/bash os &&\
  usermod -aG wheel os &&\
  echo -e "RANDOMPWD\nRANDOMPWD" | passwd os
  #echo -e "y\nRANDOMPWD" | ./crc setup
#USER os
CMD ["/bin/bash"]

# sudo ln -s /sys/module/kvm_intel /lib/modules/6.1.0-37-amd64/kvm_intel