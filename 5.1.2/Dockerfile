FROM confluentinc/cp-schema-registry:5.1.2
MAINTAINER Hermann Mayer "hermann.mayer@hausgold.de"

# You can change this environment variable on run's with -e
ENV MDNS_HOSTNAME=schema-registry.local

# Install system packages
RUN apt-get update -yqqq && \
  apt-get install -y \
    dbus avahi-daemon avahi-utils libnss-mdns nginx supervisor

# Copy avahi.sh
COPY config/avahi.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/avahi.sh

# Copy schema-registry.sh
COPY config/schema-registry.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/schema-registry.sh

# Configure nginx
COPY config/nginx/default /etc/nginx/sites-enabled/default

# Configure supervisord
COPY config/supervisor/* /etc/supervisor/conf.d/

# Define the command to run per default
CMD /usr/bin/supervisord -nc /etc/supervisor/supervisord.conf
