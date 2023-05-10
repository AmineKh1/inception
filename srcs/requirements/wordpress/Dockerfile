FROM debian:buster
RUN apt-get update

RUN apt-get install -y php
RUN apt-get install -y php-fpm
RUN apt-get install -y php-mysql
RUN apt-get install -y mariadb-client
RUN apt-get install -y curl
RUN mkdir wordpress
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp
RUN cd wordpress && wp core --allow-root download
RUN cd && mkdir /run/php

# && apt-get -y install php-cli php-mysql php-curl php-gd php-intl
EXPOSE 9000
# COPY wp-config.php /wp-config.php
COPY tools/create.sh /
COPY conf/www.conf /etc/php/7.3/fpm/pool.d/
RUN chmod +x /create.sh
CMD ["/create.sh"]