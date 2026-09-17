FROM alpine:latest

RUN apk add --no-cache nginx envsubst ca-certificates

# سحب نواة Xray الرسمية الجاهزة والمستقرة
COPY --from=ghcr.io/xtls/xray-core:latest /usr/bin/xray /usr/bin/xray
COPY --from=ghcr.io/xtls/xray-core:latest /usr/share/xray /usr/share/xray

WORKDIR /etc/xray
COPY config.json /etc/xray/config.json

# إعداد ملف الـ Nginx كواجهة ويب لاستقبال طلبات جوجل
RUN echo 'server { \
    listen 8080; \
    server_name localhost; \
    location /xray-wt/mustapha35 { \
        proxy_redirect off; \
        proxy_pass http://127.0.0.1:10000; \
        proxy_http_version 1.1; \
        proxy_set_header Upgrade $http_upgrade; \
        proxy_set_header Connection "upgrade"; \
        proxy_set_header Host $http_host; \
    } \
}' > /etc/nginx/http.d/default.conf

# أمر تشغيل خادم الويب والـ Xray معاً بصلاحيات كاملة وآمنة
CMD nginx && xray run -config /etc/xray/config.json
