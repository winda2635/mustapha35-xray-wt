FROM alpine:latest

RUN apk add --no-cache nginx ca-certificates curl unzip

RUN mkdir -p /tmp/xray && \
    curl -L -f -o /tmp/xray.zip https://github.com && \
    unzip /tmp/xray.zip -d /tmp/xray && \
    mv /tmp/xray/xray /usr/bin/xray && \
    rm -rf /tmp/xray*

WORKDIR /etc/xray
COPY config.json /etc/xray/config.json

CMD sh -c "echo 'server { \
    listen '$PORT'; \
    server_name localhost; \
    location /xray-wt/mustapha35 { \
        proxy_redirect off; \
        proxy_pass http://127.0.0.1:10000; \
        proxy_http_version 1.1; \
        proxy_set_header Upgrade \$http_upgrade; \
        proxy_set_header Connection \"upgrade\"; \
        proxy_set_header Host \$http_host; \
    } \
}' > /etc/nginx/http.d/default.conf && xray run -config /etc/xray/config.json & nginx -g 'daemon off;'"
