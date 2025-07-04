![mDNS enabled confluentinc/cp-schema-registry](https://raw.githubusercontent.com/hausgold/docker-schema-registry/master/docs/assets/project.svg)

[![Continuous Integration](https://github.com/hausgold/docker-schema-registry/actions/workflows/package.yml/badge.svg?branch=master)](https://github.com/hausgold/docker-schema-registry/actions/workflows/package.yml)
[![Source Code](https://img.shields.io/badge/source-on%20github-blue.svg)](https://github.com/hausgold/docker-schema-registry)
[![Docker Image](https://img.shields.io/badge/image-on%20docker%20hub-blue.svg)](https://hub.docker.com/r/hausgold/schema-registry/)

This Docker images provides the [confluentinc/cp-schema-registry](https://hub.docker.com/r/confluentinc/cp-schema-registry) image as base
with the mDNS/ZeroConf stack on top. So you can enjoy the app
while it is accessible by default as *schema-registry.local*. (Port 80)

- [Requirements](#requirements)
- [Getting starting](#getting-starting)
- [docker-compose usage example](#docker-compose-usage-example)
- [Host configs](#host-configs)
- [Configure a different mDNS hostname](#configure-a-different-mdns-hostname)
- [Other top level domains](#other-top-level-domains)
- [Further reading](#further-reading)

## Requirements

* Host enabled Avahi daemon
* Host enabled mDNS NSS lookup

## Getting starting

To get a [Schema Registry](https://github.com/confluentinc/schema-registry)
service up and running create a `docker-compose.yml` and insert the following
snippet:

```yaml
services:
  schema-registry:
    image: hausgold/schema-registry
    environment:
      # Mind the .local suffix
      MDNS_HOSTNAME: schema-registry.local
      # Defaults to http://0.0.0.0:8081
      SCHEMA_REGISTRY_LISTENERS: http://0.0.0.0:8081
      # Defaults to kafka.local:9092
      SCHEMA_REGISTRY_KAFKASTORE_BOOTSTRAP_SERVERS: kafka.local:9092
      # Set the default Apache Avro schema compatibility
      #
      # See: http://bit.ly/2TcpoY1
      # See: http://bit.ly/2Hfo4wj
      SCHEMA_REGISTRY_AVRO_COMPATIBILITY_LEVEL: full
    ports:
      # The ports are just for you to know when configure your
      # container links, on depended containers
      - "80" # CORS-enabled nginx proxy to the schema-registry
      - "8081" # direct access to the schema-registry (no CORS)

  schema-registry-ui:
    image: hausgold/schema-registry-ui:0.9.5
    network_mode: bridge
    environment:
      MDNS_HOSTNAME: schema-registry-ui.local
      SCHEMAREGISTRY_URL: http://schema-registry.local

  kafka:
    image: hausgold/kafka
    environment:
      MDNS_HOSTNAME: kafka.local
      # See: http://bit.ly/2UDzgqI for Kafka downscaling
      KAFKA_HEAP_OPTS: -Xmx256M -Xms32M
    ulimits:
      # Due to systemd/pam RLIMIT_NOFILE settings (max int inside the
      # container), the Java process seams to allocate huge limits which result
      # in a +unable to allocate file descriptor table - out of memory+ error.
      # Lowering this value fixes the issue for now.
      #
      # See: http://bit.ly/2U62A80
      # See: http://bit.ly/2T2Izit
      nofile:
        soft: 100000
        hard: 100000
```

Afterwards start the service with the following command:

```bash
$ docker-compose up
```

## Host configs

Install the nss-mdns package, enable and start the avahi-daemon.service. Then,
edit the file /etc/nsswitch.conf and change the hosts line like this:

```bash
hosts: ... mdns4_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] dns ...
```

## Configure a different mDNS hostname

The magic environment variable is *MDNS_HOSTNAME*. Just pass it like that to
your docker run command:

```bash
$ docker run --rm -e MDNS_HOSTNAME=something.else.local hausgold/schema-registry
```

This will result in *something.else.local*.

You can also configure multiple aliases (CNAME's) for your container by
passing the *MDNS_CNAMES* environment variable. It will register all the comma
separated domains as aliases for the container, next to the regular mDNS
hostname.

```bash
$ docker run --rm \
  -e MDNS_HOSTNAME=something.else.local \
  -e MDNS_CNAMES=nothing.else.local,special.local \
  hausgold/schema-registry
```

This will result in *something.else.local*, *nothing.else.local* and
*special.local*.

## Other top level domains

By default *.local* is the default mDNS top level domain. This images does not
force you to use it. But if you do not use the default *.local* top level
domain, you need to [configure your host avahi][custom_mdns] to accept it.

## Further reading

* Docker/mDNS demo: https://github.com/Jack12816/docker-mdns
* Archlinux howto: https://wiki.archlinux.org/index.php/avahi
* Ubuntu/Debian howto: https://wiki.ubuntuusers.de/Avahi/

[custom_mdns]: https://wiki.archlinux.org/index.php/avahi#Configuring_mDNS_for_custom_TLD
