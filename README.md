# CertFront
Publish your web application with full managed SSL certificate.

## Features
- Automatically issue and renew SSL certificate, powered by Certbot.
- Accept HTTP (port 80) request and redirect to HTTPS.
- Accept HTTPS (port 443) request and proxy to your web application.

## Example
``` yaml:docker-compose.yml
version: '3'

services:

  # Your Web Application
  app:
    build: .

  certfront:
    image: hoto17296/certfront
    ports:
      - 80:80
      - 443:443
    environment:
      DOMAIN: example.com
      EMAIL: mail@example.com
      APP_HOST: app
      APP_PORT: 5000
    volumes:
      - certs:/etc/letsencrypt
    depends_on:
      - app

volumes:

  # The certificate and private key are stored on this volume
  certs:
    driver: local
```
