#!/bin/bash
function get_ssl ()
{
 DOMAIN="$1"
 DOMAIN_SSL_DIR="${SSL_DIR}/${DOMAIN}/"
 mkdir -p "${DOMAIN_SSL_DIR}/acme"
 ACME_CLI_ARGS="-nNv -C /var/www/acme/.well-known/acme-challenge/ \
 -f ${DOMAIN_SSL_DIR}/acme/account.key \
 -k ${DOMAIN_SSL_DIR}/private.key \
 -c ${DOMAIN_SSL_DIR} \
 ${DOMAIN}"
 acme-client ${ACME_CLI_ARGS}
 ACME_ERR=$?
}

SSL_DIR="/etc/nginx/ssl"
IFS=',' read -r -a DOM_ARR <<< "${DOMAINS_LIST}"
ACME_ERR=0
sleep $(( RANDOM % 10 ))
while true; do
  for DM in ${DOM_ARR[@]}; do
    get_ssl ${DM}
  done
  if [ -z "${FIRST_RUN}" ]; then 
    cp /etc/nginx/conf.d/configs/* /etc/nginx/conf.d/
    FIRST_RUN="false"
  fi
  # [ ${ACME_ERR} -eq 0 ] && 
  while true; do
     nginx -t
     OUT=$?
     [ ${OUT} -eq 0 ] && break
     sleep 10
  done
  nginx -s reload
  sleep 3600
done
