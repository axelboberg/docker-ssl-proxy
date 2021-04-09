#!/bin/sh

# Loop through the proxies and generate
# NGINX-configurations for each
SERVERS=$(jq 'reduce .proxies[] as $proxy (""; . + 
    "server {
      server_name " + $proxy.domain + ";

      location / {
          limit_req zone=ratelimit burst=20 nodelay;
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
    map \$http_upgrade \$connection_upgrade {
      default upgrade;
      ''      close;
    }

    limit_req_zone \$binary_remote_addr zone=ratelimit:10m rate=10r/s;
    $SERVERS
  }
"

# Write config to a file
printf '%b\n"' "$CONFIG" | tr -d '"' > /etc/nginx/nginx.conf