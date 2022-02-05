FROM python:2

#FROM ubuntu:latest
#ENV DEBIAN_FRONTEND noninteractive

EXPOSE 53
RUN apt-get -yqq update && apt-get -yqq install supervisor
RUN mkdir -p /doh-poc/
COPY dnsOverTls.py /
COPY App.py /
COPY ca-certificate.crt /
COPY logger.py /
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN mkdir -p /var/log/dns-over-tls/
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
