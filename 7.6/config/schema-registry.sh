#!/usr/bin/env bash

# Configure application defaults
export SCHEMA_REGISTRY_KAFKASTORE_BOOTSTRAP_SERVERS=${SCHEMA_REGISTRY_KAFKASTORE_BOOTSTRAP_SERVERS:-'kafka.local:9092'}
export SCHEMA_REGISTRY_HOST_NAME=${SCHEMA_REGISTRY_HOST_NAME:-${MDNS_HOSTNAME}}
export SCHEMA_REGISTRY_LISTENERS=${SCHEMA_REGISTRY_LISTENERS:-'http://0.0.0.0:80'}

# Start the original bootstrapping
exec /etc/confluent/docker/run
