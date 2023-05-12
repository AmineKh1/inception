#!/bin/bash
sleep 10

chown -R www-data /wordpress
cd wordpress

rm -rf wp-config.php

wp core config --allow-root --dbhost=${MYSQL_HOST} --dbname=${MYSQL_DB} --dbuser=${MYSQL_USER} --dbpass=${MYSQL_PASSWORD}

wp config set --allow-root 'FS_METHOD' ${WP_FS_METHOD};
wp config set --allow-root 'WP_REDIS_HOST' ${WP_REDIS_HOST};
wp config set --allow-root 'WP_REDIS_PORT' ${WP_REDIS_PORT};
# cd wordpress
chmod +x wp-config.php

wp core install --allow-root --url=${URL_DNS} --title=${WP_TITLE} --admin_user=${WP_ADMIN} --admin_password=${WP_ADMIN_PSW} --admin_email=${WP_ADMIN_EMAIL}
wp user --allow-root create ${WP_USER} ${WP_EMAIL} --role=author --user_pass=${WP_USER}
wp plugin install --allow-root redis-cache --activate
wp redis enable --allow-root

exec php-fpm7.3 -F -R