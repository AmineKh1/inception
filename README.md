# inception
This project aims to broaden your knowledge of system administration by using Docker. It involves setting up a small infrastructure composed of different services using Docker and Docker Compose. The project must be done on a Virtual Machine, and each service should run in a dedicated container.
## Prerequisites
Before starting the project, make sure you have the following installed on your machine:

- Docker
- Docker Compose
## Containers
### MariaDB
The MariaDB container is responsible for running the MariaDB server, which serves as the database for the WordPress application.
Dockerfile:
```Dockerfile
FROM debian:buster

# Install mariadb-server
RUN apt-get update && apt-get install -y mariadb-server

# Allow connections from outside the container
RUN sed -i 's/^bind-address\s*=.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# Copy the script to create the database and user
COPY tools/create.sh /
RUN chmod 777 /create.sh
# Set the necessary environment variables for the script
ARG  MYSQL_USER MYSQL_PASSWORD MYSQL_DB MYSQL_HOST DB_ROOT_PASSWORD
# Run the script to create the database and user during container build
RUN service mysql start && ./create.sh
# Start the MariaDB server
CMD ["mysqld"]
```

The Dockerfile sets up the MariaDB container by installing the mariadb-server package and allowing connections from outside the container. It copies the create.sh script into the container and sets the necessary permissions. It also sets the environment variables required for the script.

The create.sh script is run during the container build process. It creates the database and user, grants privileges, and performs other necessary configurations.

Please note that the script assumes the values of the environment variables (MYSQL_USER, MYSQL_PASSWORD, MYSQL_DB, MYSQL_HOST, DB_ROOT_PASSWORD) will be provided during the container build or deployment process.

Ensure that you have the create.sh script in the tools/ directory within your project structure.

Feel free to modify the script or Dockerfile according to your specific needs and configurations.

Remember to provide the appropriate values for the environment variables when building or running the container.

### wordpress
The WordPress container runs the WordPress application using PHP-FPM.
Dockerfile:

```Dockerfile
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

# EXPOSE 9000 (Optional: Uncomment if necessary)

COPY tools/create.sh /
RUN sed -i 's~listen = /run/php/php7\.3-fpm\.sock~listen = 9000~' /etc/php/7.3/fpm/pool.d/www.conf
RUN chmod +x /create.sh
CMD ["/create.sh"]
```
create.sh:
```bash
#!/bin/bash
sleep 10

chown -R www-data /wordpress
cd wordpress

rm -rf wp-config.php

wp core config --allow-root --dbhost=${MYSQL_HOST} --dbname=${MYSQL_DB} --dbuser=${MYSQL_USER} --dbpass=${MYSQL_PASSWORD}

wp config set --allow-root 'FS_METHOD' ${WP_FS_METHOD};
wp config set --allow-root 'WP_REDIS_HOST' ${WP_REDIS_HOST};
wp config set --allow-root 'WP_REDIS_PORT' ${WP_REDIS_PORT};

chmod +x wp-config.php

wp core install --allow-root --url=${URL_DNS} --title=${WP_TITLE} --admin_user=${WP_ADMIN} --admin_password=${WP_ADMIN_PSW} --admin_email=${WP_ADMIN_EMAIL}
wp user --allow-root create ${WP_USER} ${WP_EMAIL} --role=author --user_pass=${WP_USER}
wp plugin install --allow-root redis-cache --activate
wp redis enable --allow-root

exec php-fpm7.3 -F -R
```

The Dockerfile installs the necessary PHP, PHP-FPM, and MariaDB client packages. It also downloads and configures the WP-CLI tool to manage WordPress installations. The create.sh script is copied into the container and made executable. It modifies the WordPress configuration, installs plugins, enables Redis caching, and starts the PHP-FPM server.

Ensure that you have the create.sh script in the tools/ directory within your project structure.

Feel free to customize the script or Dockerfile based on your specific requirements and configurations.

Remember to provide the appropriate values for the environment variables used in the script when building or running the container.
### Nginx Container
The Nginx container serves as a reverse proxy and handles incoming web requests for various services in our project. It also provides SSL encryption for secure communication.
####  Dockerfile
The Dockerfile for the Nginx container installs Nginx and OpenSSL, copies the SSL certificate and key files, and updates the Nginx configuration.
FROM debian:buster
```Dockerfile
RUN apt-get update && apt-get install -y nginx && apt-get install -y openssl

COPY tools/nginx-selfsigned.key /etc/ssl/private/nginx-selfsigned.key
COPY tools/nginx-selfsigned.crt /etc/ssl/certs/nginx-selfsigned.crt
COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
```
#### Nginx Configuration
The Nginx configuration file (nginx.conf) is responsible for setting up the reverse proxy, SSL encryption, and handling various locations. It also includes proxy parameters for seamless communication with the backend services.
```conf
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
    worker_connections 768;
}

http {
    server {
        listen 443 ssl;
        ssl_protocols TLSv1.3 TLSv1.2;
        ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
        ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;

        # Reverse proxy for WordPress
        location / {
            include proxy_params;
            proxy_pass http://wordpress:9000;
        }

        # Reverse proxy for Adminer
        location /adminer {
            proxy_pass http://adminer:8080;
        }

        # Reverse proxy for Portfolio
        location /portfolio/ {
            proxy_pass http://portfolio:4200;
        }

        location ~ /portfolio/(.*) {
            proxy_pass http://portfolio:4200/$1;
        }

        location ~ \.php$ {
            include /etc/nginx/fastcgi_params;
            fastcgi_param REQUEST_METHOD $request_method;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            fastcgi_pass wordpress:9000;
        }
    }

    server {
        listen 443 ssl;
        ssl_protocols TLSv1.3 TLSv1.2;
        ssl_ciphers AES128-SHA:AES256-SHA:RC4-SHA:DES-CBC3-SHA:RC4-MD5;
        ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
        ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;

        server_name portainer.akhouya.42.fr;

        location / {
            include proxy_params;
            proxy_pass http://portainer:9000;
        }
    }
}
```

Make sure to replace wordpress, adminer, portfolio, and portainer with the appropriate hostnames or container names for your project.

By configuring Nginx as a reverse proxy, we can efficiently manage multiple services on a single server and handle SSL encryption for secure communication.

You can find the SSL certificate and key files in the tools directory.
## Getting Started
