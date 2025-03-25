FROM nginx:1.27.4

EXPOSE 80/tcp
EXPOSE 443/tcp

# Install dependencies
RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
    certbot \
    python3-certbot-nginx \
    jq \
    cron

WORKDIR /home
COPY . .

# Run setup
CMD [ "sh", "/home/setup.sh" ]