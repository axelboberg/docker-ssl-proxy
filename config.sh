#!/bin/sh

# Loop through the proxies and generate
# NGINX-configurations for each
SERVERS=$(jq 'reduce .proxies[] as $proxy (""; . + 
    "server {
      server_name " + $proxy.domain + ";

      location / {
          proxy_pass " + $proxy.location + ";
          proxy_set_header X-Forwarded-For $remote_addr;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header Host $host;
          " + ($proxy.raw // "") + "
      }
    }\n"
)' < /etc/proxy/config.json)

# Wrap the generated server-blocks
# in a default configuration
CONFIG="
  events {
    worker_connections  1024;
  }

  http {
    $SERVERS
  }
"

# Write config to a file
printf '%b\n"' "$CONFIG" | tr -d '"' > /etc/nginx/nginx.conf