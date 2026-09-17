FROM ghcr.io/xtls/xray-core:latest

LABEL maintainer="mustapha35"

WORKDIR /etc/xray

COPY config.json /etc/xray/config.json

ENV XRAY_LOCATION_ASSET=/usr/share/xray

CMD sh -c "sed -i 's/\"port\": 8080/\"port\": '$PORT'/g' /etc/xray/config.json && xray run -config /etc/xray/config.json"
