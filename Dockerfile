FROM nginx:alpine

EXPOSE 80 443

RUN apk add --no-cache --virtual .certbot-deps \
        python3 py3-pip libffi openssl ca-certificates

RUN apk add --no-cache --virtual .build-deps \
        gcc python3-dev musl-dev libffi-dev openssl-dev \
    && pip3 install --no-cache-dir certbot \
    && apk del .build-deps

RUN echo -e '#!/bin/sh\n\ncertbot renew\nnginx -s reload' > /etc/periodic/monthly/renew.sh \
    && chmod +x /etc/periodic/monthly/renew.sh \
    && mkdir -p /var/www/.well-known/acme-challenge

RUN rm -rf /etc/nginx/nginx.conf /etc/nginx/conf.d

COPY run.sh /
COPY nginx.conf.template /etc/nginx

CMD ["sh", "/run.sh"]
