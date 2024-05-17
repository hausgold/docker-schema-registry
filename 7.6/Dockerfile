FROM confluentinc/cp-schema-registry:7.6.1
MAINTAINER Hermann Mayer "hermann.mayer@hausgold.de"

# You can change this environment variable on run's with -e
ENV MDNS_HOSTNAME=schema-registry.local

# Switch to the root user
USER root

# Install the CentOS 8 BaseOS and OKay's Additional RPM
# repositories for avahi/avahi-tools
COPY config/extra.repo /etc/yum.repos.d/extra.repo

# Install system packages
RUN dnf install -y \
  https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
  https://dl.fedoraproject.org/pub/epel/epel-next-release-latest-8.noarch.rpm \
  https://dl.fedoraproject.org/pub/epel/9/Everything/x86_64/Packages/s/supervisor-4.2.2-3.el9.noarch.rpm && \
  microdnf install hostname dbus avahi nss-mdns && \
  microdnf clean all

# Copy custom scripts
COPY config/*.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*

# Configure supervisord
COPY config/supervisor/* /etc/supervisord.d/

# Clear the default entrypoint, as it is the mc command
ENTRYPOINT []

# Define the command to run per default
CMD /usr/bin/supervisord -nc /etc/supervisord.conf
