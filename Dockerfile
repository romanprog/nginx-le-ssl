FROM nginx:1.19.2-alpine

RUN apk --no-cache add bash openssl  \
   && openssl dhparam -dsaparam -out /etc/nginx/dhparam.pem 4096 \
   && curl https://get.acme.sh | sh

ADD ./start.sh /
ADD ./ssl_processing.sh /
ADD ./acme.conf /etc/nginx/conf.d/

ENTRYPOINT ["/start.sh"]

