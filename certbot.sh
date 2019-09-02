#!/bin/sh

# Generate a string of all domain-names
# for use in the certbot command
DOMAINS=$(jq --raw-output 'reduce .proxies[] as $proxy (""; . + 
    " -d " + $proxy.domain
)' < /etc/proxy/config.json)

# Find the email-address that should
# be used for agreeing to the tos
EMAIL=$(jq .certbot.email < /etc/proxy/config.json)

# Use certbot to create an SSL certificate
certbot --nginx -n $DOMAINS --agree-tos --email $EMAIL

# Create a file for root's cronjobs
CRONFILE="/var/spool/cron/root"
touch $CRONFILE

# Insert cronjob to try to renew
# certificate everyday at 03:00
echo "0 3 * * * certbot -q renew" >> $CRONFILE

# Activate cronfile
crontab $CRONFILE