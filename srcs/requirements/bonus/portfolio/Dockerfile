# Base image
FROM debian:buster

# Set working directory
WORKDIR /app

# Update and install required packages
RUN apt-get update && apt-get install -y curl gnupg
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

# Install Angular CLI
RUN npm install -g @angular/cli

# Copy package.json and package-lock.json
# COPY package*.json ./

# # Install app dependencies

# RUN mkdir app
# # Copy app source code
COPY appe .
RUN npm install
# # Expose port
# EXPOSE 4200
# RUN ng build
# # Start app
# CMD ["cd app"]
CMD ["ng", "serve", "--host" ,"0.0.0.0" , "--disable-host-check"]
