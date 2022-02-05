FROM python:2

EXPOSE 53
RUN apt-get -yqq update && apt-get -yqq install supervisor
COPY dot/dnsOverTlsApp.py /
COPY dot/dnsOverTlsProxy.py /
COPY dot/ca-cloudflare.crt /
COPY dot/logger.py /
COPY dot/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN mkdir -p /var/log/dot/
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]