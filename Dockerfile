FROM alpine:latest

RUN apk update && apk add nginx && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /run/nginx && \
    mkdir -p /var/www/docker_project/img

COPY index.html /var/www/docker_project/
COPY /img/* /var/www/docker_project/img/
COPY index.html /var/lib/nginx/html/

RUN chmod -R 755 /var/www/docker_project && \
    adduser -D valerian && \
    addgroup valerian_group && \
    addgroup valerian valerian_group && \
    chown -R valerian:valerian_group /var/www/docker_project

RUN apk add --no-cache curl && \
    curl -o /etc/nginx/nginx.conf https://raw.githubusercontent.com/nginx/nginx/master/conf/nginx.conf && \
    sed -i 's/user nginx/user valerian/' /etc/nginx/nginx.conf && \
    sed -i 's/\/var\/www\/html/\/var\/www\/docker_project/g' /etc/nginx/nginx.conf && \
    rm -rf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]