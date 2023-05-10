FROM debian:buster


RUN apt-get update \
    && apt-get install -y wget tar \
    && wget https://github.com/portainer/portainer/releases/download/2.17.1/portainer-2.17.1-linux-amd64.tar.gz \
    # && wget https://github.com/portainer/portainer/releases/download/2.16.2/portainer-2.16.2-linux-amd64.tar.gz \
    && tar xvzf /portainer-2.17.1-linux-amd64.tar.gz \
    && rm -rf portainer-2.17.1-linux-amd64.tar.gz
# RUN mkdir /data
CMD ["/portainer/portainer"]