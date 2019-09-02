FROM nginx:1.15.12

EXPOSE 80/tcp
EXPOSE 443/tcp

# Install dependencies
RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
    certbot \
    python-certbot-nginx \
    jq \
    cron

WORKDIR /home
COPY . .

# Reaload nginx to take advantage of the new configuration
CMD [ "sh", "/home/setup.sh" ]