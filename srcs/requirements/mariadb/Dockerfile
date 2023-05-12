FROM debian:buster

# Install mariadb-server
RUN apt-get update && apt-get install -y mariadb-server

RUN sed -i 's/^bind-address\s*=.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/create.sh /
RUN chmod 777 /create.sh
# CMD ["/create.sh"]
# FROM debian:buster

# RUN apt update \
#    && apt install -y mariadb-server

ARG  MYSQL_USER MYSQL_PASSWORD MYSQL_DB MYSQL_HOST DB_ROOT_PASSWORD
# COPY ./tools/create.sh .
# RUN chmod 777 create.sh

RUN service mysql start && ./create.sh

CMD ["mysqld"]
