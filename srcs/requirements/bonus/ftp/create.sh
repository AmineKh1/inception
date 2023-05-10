#!/bin/bash
adduser --disabled-password --gecos "" akhouya42
echo "akhouya42" | tee -a  /etc/vsftpd.userlist
echo "akhouya42:1234" | chpasswd
mkdir -p /home/akhouya42/ftp_directory
chown akhouya42:akhouya42 /home/akhouya42/ftp_directory
cd /home/akhouya42
chmod -R 777 ftp_directory
exec vsftpd