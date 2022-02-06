# DNS over TLS Proof of Concept

This is a Python application which works as a Proxy. It listen DNS queries and redirects to DNS over TLS according the [RFC7858 - Specification for DNS over Transport Layer Security (TLS)](https://tools.ietf.org/html/rfc7858).

This PoC is tested using the Cloudflare DNS Server (IP Address `1.1.1.1`) which already implements DNS-over-TLS.

## Running the PoC - Steps

### 1. Build and run the DNS-over-TLS Proxy in a Docker instance

1. Content of this repository:
```sh
$ tree .
.
├── 1_run.sh
├── 2_delete.sh
├── dnsQueryCli.py
├── dot
│   ├── ca-cloudflare.crt
│   ├── dnsOverTlsApp.py
│   ├── dnsOverTlsProxy.py
│   ├── Dockerfile
│   ├── logger.py
│   └── supervisord.conf
├── LICENSE
└── README.md

1 directory, 11 files
```

2. Build Docker image and run a Docker instance
```sh
$ ./1_run.sh

Sending build context to Docker daemon  13.31kB
Step 1/10 : FROM python:2
 ---> 68e7be49c28c
Step 2/10 : RUN DEBIAN_FRONTEND=noninteractive apt-get -yqq update && apt-get -yqq install supervisor
 ---> Using cache
 ---> 31d081df8b0b
Step 3/10 : EXPOSE 53
 ---> Using cache
 ---> 5a5fd460ff4b
Step 4/10 : COPY dnsOverTlsApp.py /dot/
 ---> Using cache
 ---> 532be8136449
Step 5/10 : COPY dnsOverTlsProxy.py /dot/
 ---> Using cache
 ---> 7bd515678faa
Step 6/10 : COPY ca-cloudflare.crt /dot/
 ---> Using cache
 ---> 5aa1fc16ba93
Step 7/10 : COPY logger.py /dot/
 ---> Using cache
 ---> 80d25eb8248e
Step 8/10 : COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
 ---> Using cache
 ---> 58d6b37877e0
Step 9/10 : RUN mkdir -p /var/log/dot/
 ---> Running in 42de663c294e
Removing intermediate container 42de663c294e
 ---> b20ce28119ac
Step 10/10 : CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
 ---> Running in 6b46a1a62b95
Removing intermediate container 6b46a1a62b95
 ---> 113cee681a0e
Successfully built 113cee681a0e
Successfully tagged dnsovertlsproxy:latest
5f0fd22f6c8e55bb93af8d3f5da59669b0db5c87861ad87b02fbc7fab9977211

=> Docker instance created.
CONTAINER ID   NAMES       PORTS                                   IMAGE
5f0fd22f6c8e   dotproxy1   0.0.0.0:5353->53/tcp, :::5353->53/tcp   dnsovertlsproxy

=> To show stdout logs run next command: 
	 docker logs -f dotproxy1
```

### 2. Testing the DNS-over-TLS Proxy

We are going to use an ad-hoc DNS client implemented in Python3 which will send the DNS queries to Proxy in the `5353` port. The Proxy will redirect the DNS query and it will encapsulate in a TLS packet, according the `RFC7858`, and will send it to Cloudflare DNS.


```
dnsQueryCli => dns-pckt(127.0.0.1:5353) => Docker(dns-pckt convert to dns-over-tls-pckt) => Docker (send dns-over-tls-pckt) => Cloudflare DNS
```

DNS queries:
```sh
$ python3 dnsQueryCli.py holisticsecurity.io 
b'185.199.111.153'

$ python3 dnsQueryCli.py yahoo.com 
b'98.137.11.163'
```

### 3. Getting the logs

In other Terminal debug the `dotproxy1` Docker instance (DNS-over-TLS Proxy).  
To show the Application logs run this:
```sh
docker exec -it dotproxy1 tail -f /var/log/dot/app.log
```

To show the Docker logs in Json format:
```sh
CONTAINER_ID=$(docker inspect --format="{{.Id}}" dotproxy1)
sudo tail -f  /var/lib/docker/containers/${CONTAINER_ID}/${CONTAINER_ID}-json.log | jq
```

Or if you want to show the classic format:
```sh
docker logs -f dotproxy1
```

### 3. Cleaning up

Just run the `2_delete.sh` script:
```sh
$ ./2_delete.sh

dotproxy1
dotproxy1
Untagged: dnsovertlsproxy:latest
Deleted: sha256:113cee681a0e0319f8112e473403c7339fad40d6db536cb9c961f1fc8f3269aa
Deleted: sha256:b20ce28119ac9cd03578cfbd552e937cab27279964450362b705ecfa156cdcc6
Deleted: sha256:b44401fdd8ae3dbbb6a9aebb575abdee2d79a02108352ca2b75549f5018055e5

=> Docker image and instance removed.
=> Listing current Docker instances:
CONTAINER ID   NAMES     PORTS     IMAGE

```
