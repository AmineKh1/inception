FROM debian:buster

RUN apt-get update && apt-get install -y wget php  php-mysql  \
    && mkdir -p /var/www/html/adminer/ \
    && wget "http://www.adminer.org/latest.php" -O /var/www/html/adminer/index.php \
    && mkdir /run/php/
WORKDIR /var/www/html/adminer/

CMD php -S 0.0.0.0:8080

