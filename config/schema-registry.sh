#!/bin/bash

# Configure application defaults
export SCHEMA_REGISTRY_KAFKASTORE_CONNECTION_URL=${SCHEMA_REGISTRY_KAFKASTORE_CONNECTION_URL:-'zookeeper:2181'}
export SCHEMA_REGISTRY_HOST_NAME=${SCHEMA_REGISTRY_HOST_NAME:-${MDNS_HOSTNAME}}
export SCHEMA_REGISTRY_LISTENERS=${SCHEMA_REGISTRY_LISTENERS:-'http://0.0.0.0:8081'}

# Start the original bootstrapping
source /etc/confluent/docker/run
