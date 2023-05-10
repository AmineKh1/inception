FROM debian:buster

RUN apt-get update 
RUN apt-get install -y redis-server php-redis
# RUN apt-get update \
#     && apt-get install -y redis \
#     && apt-get install -y php7.3-redis

CMD redis-server --protected-mode no