FROM nginx:alpine

RUN apk --no-cache add bash openssl acme-client \
   && openssl dhparam -dsaparam -out /etc/nginx/dhparam.pem 4096

ADD ./start.sh /
ADD ./ssl_processing.sh /
ADD ./acme.conf /etc/nginx/conf.d/

ENTRYPOINT ["/start.sh"]

