# docker-ssl-proxy
A Docker image using NGINX and Certbot to create a reverse-proxy that also creates and maintains an SSL certificate for your domains.

## Configuration
Configuration is done through creating a file `config.json` and binding it to `/etc/proxy/config.json`.

```
{
  "certbot": {
    "email": "" // Your email-address for agreeing to Certbot's terms of service
  },
  "proxies": [
    {
      "domain": "example.com", // The domain you want to forward and include in the SSL-certificate
      "location": "http://localhost:3000" // The location you want to forward to
    }
  ]
}
```

## Run
Run the container by using the following command to also attach to the host-net.

Remember to also bind `/etc/letsencrypt` to a host directory or new certificates will be generated every time the container restarts. 

```
docker run -d \
  --net="host" --restart unless-stopped \
  --mount type=bind,source=my-config-directory,target=/etc/proxy \
  --mount type=bind,source=my-certificate-directory,target=/etc/letsencrypt \
  axelboberg/docker-ssl-proxy:1.0.1
```