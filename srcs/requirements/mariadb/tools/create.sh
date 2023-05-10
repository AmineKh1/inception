#!/bin/bash
service mysql start
mysql -u root -e "CREATE DATABASE ${MYSQL_DB}"
mysql -u root -e "GRANT ALL PRIVILEGES ON ${MYSQL_DB}.* TO ${MYSQL_USER}@'%' IDENTIFIED BY ${MYSQL_PASSWORD}"
service mysql stop

exec mysqld