FROM teddysun/xray:latest

LABEL maintainer="mustapha35"

WORKDIR /etc/xray

COPY config.json /etc/xray/config.json

USER root

RUN apk add --no-cache jq

CMD jq '.inbounds[].port = '"${PORT:-8080}"'' /etc/xray/config.json > /etc/xray/config_tmp.json && mv /etc/xray/config_tmp.json /etc/xray/config.json && xray -config /etc/xray/config.json
