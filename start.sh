#!/bin/bash

mkdir -p /var/www/acme/.well-known/acme-challenge/

/ssl_processing.sh &
/usr/sbin/nginx -g "daemon off;"
