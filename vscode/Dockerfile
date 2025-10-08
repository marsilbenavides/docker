FROM alpine:3.22.1
LABEL OWNER="OXXO"
RUN apk update &&\
    apk upgrade --no-cache &&\
    apk add --no-cache util-linux &&\
    apk add --no-cache java-cacerts &&\
    apk add --no-cache ca-certificates &&\
    apk add --no-cache openssh &&\
    apk add --no-cache openrc &&\
    apk add --no-cache openjdk17-jre-headless &&\
    update-ca-certificates &&\
    rc-update add sshd &&\
    rm -rf /var/cache/apk/* &&\
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config &&\
    addgroup -S ms &&\
    adduser -S vscode -G ms &&\
    echo -n 'vscode:vscodepwd' | chpasswd &&\
    echo -n 'root:rootpwd' | chpasswd &&\
    mkdir /home/vscode/projects &&\
    mkdir /run/openrc &&\
    ssh-keygen -A
#    touch /run/openrc/softlevel &&\
# service sshd start
#    rc-service sshd start &&\

WORKDIR /home/vscode/projects
#USER vscode
EXPOSE 22
CMD ["/usr/sbin/sshd" "-D" "-e" "\$@"]
