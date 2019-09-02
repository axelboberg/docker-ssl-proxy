#!/bin/sh

print_cyan () {
  printf "\033[1;36m$1\033[0m\n"
}

print_red () {
  printf "\033[0;31m$1\033[0m\n"
}

if ! [ -e /etc/proxy/config.json ]
then
  print_red "/etc/proxy/config.json does not exist"
  return
fi

# Generate config
print_cyan "Generating NGINX configuration"
sh config.sh

# Setup Certbot
print_cyan "Setting up Certbot"
sh certbot.sh

# Start Nginx
print_cyan "Running NGINX"
/etc/init.d/nginx stop
/usr/sbin/nginx -g 'daemon off;'