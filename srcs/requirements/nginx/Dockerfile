FROM debian:buster

# Install Nginx and OpenSSL
RUN apt-get update && apt-get install -y nginx && apt-get install -y openssl
# Generate a self-signed SSL certificate
# RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/CN=localhost"
# Copy the SSL certificate and key into the container
COPY tools/nginx-selfsigned.key /etc/ssl/private/nginx-selfsigned.key
COPY tools/nginx-selfsigned.crt /etc/ssl/certs/nginx-selfsigned.crt
# Update Nginx configuration to use SSL
COPY conf/nginx.conf etc/nginx/nginx.conf
# COPY tools/index.html /usr/share/nginx/html/
# Expose port 443 for HTTPS traffic
EXPOSE 443
# # Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
