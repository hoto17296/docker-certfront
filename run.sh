NGINX_CONF=/etc/nginx/nginx.conf

# Issue or renew certificate
echo 'events {} http { server { root /var/www; } }' > ${NGINX_CONF}
nginx -c ${NGINX_CONF}

if [[ $(certbot certificates -d ${DOMAIN} 2>/dev/null | grep -c "Certificate Name: ${DOMAIN}") -eq 0 ]]
then
  certbot certonly --webroot --webroot-path /var/www --domain ${DOMAIN} --email ${EMAIL} --agree-tos
else
  certbot renew
fi

nginx -c ${NGINX_CONF} -s quit

# Generate Nginx conf
cp /etc/nginx/nginx.conf.template ${NGINX_CONF}
sed -i -e "s/DOMAIN/${DOMAIN}/g" ${NGINX_CONF}
sed -i -e "s/APP_HOST/${APP_HOST}/g" ${NGINX_CONF}
sed -i -e "s/APP_PORT/${APP_PORT:-80}/g" ${NGINX_CONF}

if [[ -n "${STATIC_PATH}" && -n "${STATIC_ROOT}" ]]
then
  sed -i -e "s|STATIC_SERVE|location ${STATIC_PATH} { root ${STATIC_ROOT}; }|g" ${NGINX_CONF}
else
  sed -i -e "s|STATIC_SERVE||g" ${NGINX_CONF}
fi

# Start services
crond
nginx -c ${NGINX_CONF}
