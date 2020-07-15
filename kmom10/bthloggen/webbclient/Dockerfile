FROM debian:stretch-slim

RUN apt-get update && \
    apt-get -y install apache2 && \
    apt-get -y install nano && \
    apt-get install -y curl && \
    apt-get install -y jq && \
    a2enmod rewrite

COPY build/ /var/www/html/client.linux.se/
COPY ./client.linux.se.conf /etc/apache2/sites-enabled/000-default.conf

CMD apachectl -D FOREGROUND
