FROM ghcr.io/xtls/xray-core:latest

LABEL maintainer="mustapha35"

WORKDIR /etc/xray

COPY config.json /etc/xray/config.json

ENV XRAY_LOCATION_ASSET=/usr/share/xray

USER 0

CMD ["xray", "run", "-config", "/etc/xray/config.json"]
