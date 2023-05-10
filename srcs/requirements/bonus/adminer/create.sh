#!/bin/bash
service apache2 start
service mysql start
service apache2 reload
a2enconf php*-fpm
service apache2 reload
a2enconf adminer
service apache2 reload
service apache2 restart



