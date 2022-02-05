# DNS over TLS Proof of Concept

This is a Python application which works as a Proxy. It listen DNS queries and redirects to DNS over TLS according the [RFC7858 - Specification for DNS over Transport Layer Security (TLS)](https://tools.ietf.org/html/rfc7858).

This PoC is tested using the Cloudfare DNS Server (IP Address `1.1.1.1`) which already implements DNS-over-TLS.

## Running the PoC - Steps

### 1. Build and run the DNS-over-TLS Proxy in a Docker instance

1. Build Docker:
```sh
docker build -t dnsovertlsproxy .

docker images
```
You will have this:
```sh
REPOSITORY        TAG       IMAGE ID       CREATED         SIZE
dnsovertlsproxy   latest    08c084657a0a   6 seconds ago   149MB
ubuntu            latest    54c9d81cbb44   3 days ago      72.8MB
```

2. Run Docker:
```sh
docker run -d -p 5353:53 --name dotproxy1 dnsovertlsproxy

docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}\t{{.Image}}"
```
You will have this:
```sh
CONTAINER ID   NAMES       PORTS                                   IMAGE
3df1c2d60642   dotproxy1   0.0.0.0:5353->53/tcp, :::5353->53/tcp   dnsovertlsproxy
```

### 2. Testing the DNS-over-TLS Proxy

We are going to use an ad-hoc DNS client implemented in Python which will send the DNS queries to Proxy in the `5353` port. The Proxy will redirect the DNS query and will encapsulate in a TLS packet, according the `RFC7858`, and will send to Cloudflase DNS.

```sh
python3 dns_query.py google.com 

```

### 3. Getting the logs

In other Terminal debug the `dotproxy1` Docker instance (DNS-over-TLS Proxy).
```sh
CONTAINER_ID=$(docker inspect --format="{{.Id}}" dotproxy1)
sudo tail -f  /var/lib/docker/containers/${CONTAINER_ID}/${CONTAINER_ID}-json.log | jq
```
Or
```sh
docker logs -f dotproxy1
```
And the Application logs:
```sh
docker exec -it dotproxy1 tail -f /var/log/dns-over-tls/app.log
```