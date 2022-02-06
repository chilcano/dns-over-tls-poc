### 4. Questions

#### 1. How do you build, run and use your proxy locally?

* The Proxy is running in the client side, it listen for standard dns packets in the 5353 port, establish TLS connection using the Cloudflare X.509 Certificate (Server Authentication), encapsulate the original dns packet in a TLS packet with the right Cloudflare credentials and port.
* Once resolved the DNS query, the Proxy sends back to client the dns response.

#### 2. What privacy issue arises when using unencrypted communication to query DNS records?

* The unencrypted communication can be intercepted and manipulated in transit.
* If communication is unencrypted, then TLS Certificated is not used and the DNS server is not authenticated.
* Since we are using TLS Certificate only to establish secure communication and to authenticate the Cloudflare DNS server, the security is not complete because the communication between client and proxy is not secure yet.

#### 3. How would you securely integrate the proxy in a distributed, microservices-oriented and containerized architecture?

* The Proxy should be integrated as a Sidecar Container. However, this approach will impact your infraestructure since you are introdfucing an extra hop.
* As Sidecar Container you could adopt Envoy Proxy and implement dns-over-TLS as an extension, even using WASM.
* Other option is run the Proxy as DaemonSet, instead of deploying multiple Sidecars, if you are using Kubernetes or Edge Proxy in your Data Plane.

#### 4. How would you configure the clients to talk securely to the proxy?

* An internal DNS-over-TLS Proxy is a trusted internal service, its configuration should be assigned (propagated) through DHCP service or be botstrapped during client booting in the trusted network. If that client is a containerized application, a sidecar container can bootstrap this DNS configuration.
* Considering there isn't security between client and proxy, other option could be to take advantage of TLS and enable Mutual TLS Authentication. This option will require generate TLS Client Certificate and distribute them to all your clients, which can be a tedius work (Certificate rollout problem).
* Other option could be re-routing all incoming dns packets from your existing internal Router to your internal DNS-over-TLS Proxy. This Proxy will be transparent to your clients, it will work as gateway, however this option will impact the configuration of your Router.


#### 5. How would you protect the proxy against MITM attacks?

* The Proxy runs in the client side and it is sitting in a trusted network. However, the communication between Proxy and DNS Server can potentially suffer a MITM attack. This can be mitigated if using TLS to check the identity of the server side. In this case, we are using the Cloudflare DNS Certificate and with that, the Proxy can check the Cloudflare identity cryptographicaly (CRL distribution list, OCSP, SubjectAltName, etc.). We should encourage the right implementation of TLS v1.3 wich forces the validation of TLS Server Certificate and in this way we can protect against MITM attacks.

#### 6. How would you ensure the trustworthiness of the remote DNS server?

* Downloading the DNS server x.509 certificate from a trusted source and validating it when it is being imported and when it is being used at all times by the Proxy.
* Certificate validation means checking its status (revoked, expired, etc.) using CRL distribution points, OCSP services, checking cryptographic integrity.
* Other thing to be implemented through the same or other Sidecar Container is TLS Certificate Automatic renewal.

#### 7. What other improvements do you think would be interesting to add to the project?

* End-to-end encryption using TLS. Enable Mutual TLS Authentication between Proxy and DNS-over-TLS server.
* Implement in the same Proxy or Sidecar a functionality to validate the DNS-over-TLS Certificate.
* Implement in the same Proxy or Sidecar a functionality to filter and block untrusted FQDN.
* Implement in the same Proxy or Sidecar a functionality to fetch updated DNS-over-TLS certificate and if that is not possible, alert it or block the dns query or something like that.
* Monitoring the Proxy to get metrics about DNS traffic. That will allow to get a DB to do Threat Intelligence.
