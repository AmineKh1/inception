FROM debian:buster

# Install mariadb-server
RUN apt-get update && apt-get install -y mariadb-server
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/create.sh /
RUN chmod +x /create.sh
EXPOSE 3306
CMD ["/create.sh"]
