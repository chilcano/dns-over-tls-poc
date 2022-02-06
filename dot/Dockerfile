FROM python:2

RUN DEBIAN_FRONTEND=noninteractive apt-get -yqq update && apt-get -yqq install supervisor
EXPOSE 53
COPY dnsOverTlsApp.py /dot/
COPY dnsOverTlsProxy.py /dot/
COPY ca-cloudflare.crt /dot/
COPY logger.py /dot/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN mkdir -p /var/log/dot/
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]