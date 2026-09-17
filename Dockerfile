FROM alpine:3.19 AS builder

RUN apk add --no-cache curl unzip ca-certificates

ENV XRAY_VERSION=24.11.30

RUN curl -L -o /tmp/xray.zip \
    "https://github.com/XTLS/Xray-core/releases/download/v${XRAY_VERSION}/Xray-linux-64.zip" \
    && unzip /tmp/xray.zip -d /tmp/xray \
    && chmod +x /tmp/xray/xray

FROM alpine:3.19

RUN apk add --no-cache ca-certificates tzdata \
    && rm -rf /var/cache/apk/*

RUN addgroup -g 1000 xray \
    && adduser -u 1000 -G xray -s /bin/sh -D xray

COPY --from=builder /tmp/xray/xray /usr/local/bin/xray
RUN chmod +x /usr/local/bin/xray

RUN mkdir -p /etc/xray /var/log/xray \
    && chown -R xray:xray /etc/xray /var/log/xray

COPY --chown=xray:xray config.json /etc/xray/config.json

USER xray

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD xray version || exit 1

CMD ["/usr/local/bin/xray", "-config", "/etc/xray/config.json"]
