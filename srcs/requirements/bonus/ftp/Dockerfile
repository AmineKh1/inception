FROM debian:buster

RUN apt-get update
RUN apt-get install -y vsftpd
COPY vsftpd.conf /etc/vsftpd.conf
COPY create.sh /create.sh
RUN chmod 777 /etc/vsftpd.conf
RUN chmod 777 /create.sh
CMD ["/create.sh"]


