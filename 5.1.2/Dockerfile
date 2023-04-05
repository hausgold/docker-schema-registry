FROM confluentinc/cp-schema-registry:5.1.2
MAINTAINER Hermann Mayer "hermann.mayer@hausgold.de"

# You can change this environment variable on run's with -e
ENV MDNS_HOSTNAME=schema-registry.local

# Update the apt sources list
RUN echo 'deb http://archive.debian.org/debian jessie main\n\
deb http://archive.debian.org/debian-security jessie/updates main\n\
deb http://archive.debian.org/debian jessie-backports main' \
  >/etc/apt/sources.list; \
  echo 'Acquire::Check-Valid-Until "0";' \
  > /etc/apt/apt.conf.d/10no-check-valid-until

# Install system packages
RUN apt-get update -yqqq && \
  apt-get install -y --force-yes \
    dbus avahi-daemon avahi-utils libnss-mdns nginx supervisor

# Copy custom scripts
COPY config/*.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*

# Configure nginx
COPY config/nginx/default /etc/nginx/sites-enabled/default

# Configure supervisord
COPY config/supervisor/* /etc/supervisor/conf.d/
RUN mkdir -p /var/log/supervisor

# Define the command to run per default
CMD /usr/bin/supervisord -nc /etc/supervisor/supervisord.conf
