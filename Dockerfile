FROM nginx:1.16.1

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

# Run setup
CMD [ "sh", "/home/setup.sh" ]