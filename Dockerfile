############################################################
# Dockerfile to build Nginx with Letsencrypt
############################################################

# Set the base image to Ubuntu
FROM phusion/baseimage:jammy-1.0.4

# File Author / Maintainer
MAINTAINER Alex K <alexeykcontact@gmail.com>

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN rm -f /etc/service/sshd/down

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs

# Copy application
COPY ./src/logs /usr/share/mail-daemon/logs/
COPY ./src/src /usr/share/mail-daemon/src/
COPY ./src/templates /usr/share/mail-daemon/templates/
COPY ./src/package.json /usr/share/mail-daemon/

# Install node modules
# We may need this to build native modules
#RUN apt-get update; exit 0
#RUN apt-get install -y python-minimal build-essential
RUN cd /usr/share/mail-daemon && npm install

# Init
RUN mkdir -p /etc/my_init.d
COPY 01-run.sh /etc/my_init.d/01-run.sh
RUN chmod +x /etc/my_init.d/01-run.sh
