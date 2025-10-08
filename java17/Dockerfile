FROM alpine:3.22.0
LABEL OWNER="OXXO"
RUN export http_proxy="http://192.168.1.150:3128/" &&\
    export https_proxy="http://192.168.1.150:3128/" &&\
    apk update &&\
    apk upgrade --no-cache &&\
    apk add java-cacerts ca-certificates &&\
    update-ca-certificates &&\
    apk add openjdk17-jre-headless &&\
    rm -rf /var/cache/apk/*
CMD ["java", "-version"]
