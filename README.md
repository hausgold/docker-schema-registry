![mDNS enabled confluentinc/cp-schema-registry](https://raw.githubusercontent.com/hausgold/docker-schema-registry/master/docs/assets/project.png)

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

To get a [Schema Registry](https://github.com/confluentinc/schema-registry) service up and running create a
`docker-compose.yml` and insert the following snippet:

```yaml
zookeeper:
  image: hausgold/zookeeper
  ports:
    - "2181"
kafka:
  image: hausgold/kafka
  environment:
    # Mind the .local suffix
    - MDNS_HOSTNAME=kafka.local
  ports:
    # The ports are just for you to know when configure your
    # container links, on depended containers
    - "9092"
  links:
    # Link to the ZooKeeper instance for advertising
    - zookeeper
schema-registry:
  image: hausgold/schema-registry
  environment:
    # Mind the .local suffix
    MDNS_HOSTNAME: schema-registry.local
    # Defaults to zookeeper:2181
    SCHEMA_REGISTRY_KAFKASTORE_CONNECTION_URL: zookeeper:2181
  links:
    - zookeeper
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
