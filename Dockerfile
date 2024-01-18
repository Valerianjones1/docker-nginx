FROM alpine:latest

RUN apk update && apk add nginx && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /run/nginx && \
    mkdir -p /var/www/docker_project/img

COPY index.html /var/www/docker_project/
COPY /img/* /var/www/docker_project/img/

RUN chmod -R 755 /var/www/docker_project && \
    adduser -D valerian && \
    addgroup valerian_group && \
    addgroup valerian valerian_group && \
    chown -R valerian:valerian_group /var/www/docker_project

RUN sed -i 's/\/var\/www\/localhost\/htdocs/\/var\/www\/docker_project/g' /etc/nginx/http.d/default.conf && \
    nginx_user_file=$(grep -rl 'user .*;' /etc/nginx/) && \
    sed -i 's/user .*;/user valerian valerian_group;/g' "$nginx_user_file"

CMD ["nginx", "-g", "daemon off;"]