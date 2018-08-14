FROM nginx:alpine

EXPOSE 80 443

RUN apk add --no-cache --virtual .certbot-deps \
        python3 libffi openssl ca-certificates

RUN apk add --no-cache --virtual .build-deps \
        gcc python3-dev musl-dev libffi-dev openssl-dev \
    && pip3 install --no-cache-dir certbot \
    && apk del .build-deps

RUN echo -e '#!/bin/sh\n\ncertbot renew' > /etc/periodic/monthly/renew.sh \
    && chmod +x /etc/periodic/monthly/renew.sh

RUN rm -rf /etc/nginx

COPY run.sh /
COPY nginx.conf.template /etc

CMD ["sh", "/run.sh"]
