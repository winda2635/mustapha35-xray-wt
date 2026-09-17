FROM ghcr.io/xtls/xray-core:latest
WORKDIR /etc/xray
COPY config.json /etc/xray/config.json
ENV XRAY_LOCATION_ASSET=/usr/share/xray
CMD ["xray", "run", "-config", "/etc/xray/config.json"]
