FROM confluentinc/cp-schema-registry:7.6.1
MAINTAINER Hermann Mayer "hermann.mayer@hausgold.de"

# You can change this environment variable on run's with -e
ENV MDNS_HOSTNAME=schema-registry.local

# Switch to the root user
USER root

# Build stage 1 - installation of the mDNS stack, utilites, etc
RUN \
  --mount=type=bind,readwrite,source=build,target=/build \
  /build/run install

# Clear the default entrypoint, as it is the mc command
ENTRYPOINT []

# Define the command to run per default
CMD /usr/bin/supervisord -nc /etc/supervisord.conf
