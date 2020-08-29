#!/bin/bash
function get_ssl ()
{
  Domain="$1"
  AcmeHomeDir="${SSL_DIR}/acme/"
  mkdir -p ${AcmeHomeDir}
  WebRootDir="/var/www/acme/"

  /root/.acme.sh/acme.sh --debug --issue --home ${AcmeHomeDir} -w ${WebRootDir} -d ${Domain}
  
  DomainSSLDir="${SSL_DIR}/${Domain}/"
  mkdir -p "${DomainSSLDir}"
  /root/.acme.sh/acme.sh --install-cert --home ${AcmeHomeDir} -d ${Domain} --key-file ${DomainSSLDir}/private.key --fullchain-file ${DomainSSLDir}/fullchain.pem


  ACME_ERR=$?
}

SSL_DIR="/etc/nginx/ssl"
IFS=',' read -r -a DOM_ARR <<< "${DOMAINS_LIST}"
ACME_ERR=0
sleep $(( RANDOM % 20 ))
while true; do
  for DM in ${DOM_ARR[@]}; do
    get_ssl ${DM}
  done
# load configs one by one in alphabetical order.
  while read FILE_NAME; do
      if [ -z "${FIRST_RUN}" ]; then 
         cp /etc/nginx/conf.d/configs/${FILE_NAME} /etc/nginx/conf.d/
      fi
      while true; do
         nginx -t
         OUT=$?
         [ ${OUT} -eq 0 ] && break
         sleep 15
      done
      nginx -s reload
  done < <(ls /etc/nginx/conf.d/configs/ | sort -s )

  FIRST_RUN="false"
  sleep 3600
done

while read FILE_NAME
do

done < <(ls | sort -s )