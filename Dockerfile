FROM node:7-alpine
MAINTAINER Fábio Luciano <fabioluciano@php.net>


ENV USERNAME='cdn'
ENV PASSWORD='password'

RUN apk update \
  && apk --update --no-cache add openssh supervisor \
  && rm -rf /var/cache/apk/* \
  && printf "$PASSWORD\n$PASSWORD" | adduser $USERNAME \
  && printf "\n\n" | ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key \
  && printf "\n\n" | ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key \
  && printf "\n\n" | ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key \
  && printf "\n\n" | ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key \
  && echo "AllowUsers $USERNAME" >> /etc/ssh/sshd_config \
  && npm install http-server -g

COPY files/supervisord.conf /etc/

EXPOSE 8080/tcp 22/tcp
# VOLUME /var/www

ENTRYPOINT ["supervisord", "--nodaemon", "-c", "/etc/supervisord.conf", "-j", "/tmp/supervisord.pid", "-l", "/var/log/supervisord.log"]
