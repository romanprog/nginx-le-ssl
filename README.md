# nginx-auto-ssl
Docker nginx proxy for swarm with auto LE ssl processing. 

Run:

1) Clone repo. 

2) Create nginx configuration file for ssl virtual hosts, like this (note the path to the certificate):

```
server {
    listen       443 ssl;
    server_name  domain.example.com;

    auth_basic "Restricted";
    auth_basic_user_file /etc/nginx/conf.d/htpasswd;

    ssl_protocols           SSLv3 TLSv1 TLSv1.1 TLSv1.2;
    ssl_certificate         /etc/nginx/ssl/domain.example.com/fullchain.pem;
    ssl_certificate_key     /etc/nginx/ssl/domain.example.com/private.key;

    location / {
        proxy_pass        http://my-web-service:8080;
        proxy_redirect    off;
        proxy_set_header  X-Forwarded-For       $remote_addr;
        proxy_set_header  Host      $host;
    }
}
```
3) Create stack.yml:
```
version: '3'
services:
  nginx:
    image: nginx-le-ssl
    volumes:
      - ./nginx/conf.d:/etc/nginx/conf.d/configs
      - ./nginx/ssl:/etc/nginx/ssl
    environment:
        DOMAINS_LIST: "domain.example.com"
    ports:
      - "80:80"
      - "443:443"

  my-web-service:
     image: my-web-swervice-image

```
my-web-service should listen on port 8080 (do not publish port to outside).
Mount nginx config(s) to path /etc/nginx/conf.d/configs inside container.
Its nessesery to mount the directory /etc/nginx/ssl as persistent volume.

4) Run

docker stack deploy -c stack.yml mystack



