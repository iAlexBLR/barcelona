version: '3.8'

services:
  master:
    hostname: redis_1
    image: "${REDIS_SERVER_IMAGE}"
    environment:
      - REDIS_REPLICATION_MODE=master
      - REDIS_PASSWORD=${REDIS_SERVER_PASSWORD}
    expose:
      - ${REDIS_SERVER_PORT}
    volumes: &redis_data
      - type: bind
        source: "./${REDIS_SERVER_DATA_FOLDER}"
        target: "/bitnami"

{% set index_offset = 1 %}
{% for index in (range(index_offset, redis.server.replicas + index_offset) | list) %}
{% if index == 1 %}
  replica_{{ index }}: &replica
    hostname: redis_{{ index + 1 }}
    image: "${REDIS_SERVER_IMAGE}"
    environment:
      - REDIS_REPLICATION_MODE=replica
      - REDIS_MASTER_HOST=master
      - REDIS_MASTER_PORT_NUMBER=${REDIS_SERVER_PORT}
      - REDIS_MASTER_PASSWORD=${REDIS_SERVER_PASSWORD}
      - REDIS_PASSWORD=${REDIS_SERVER_PASSWORD}
    expose:
      - ${REDIS_SERVER_PORT}
    volumes: *redis_data
    depends_on:
      - master

{% else %}
  replica_{{ index }}:
    << : *replica
    hostname: redis_{{ index + 1 }}

{% endif %}
{% endfor %}
  sentinel:
    scale: ${REDIS_SENTINEL_REPLICAS}
    image: "${REDIS_SENTINEL_IMAGE}"
    environment:
      - REDIS_MASTER_HOST=master
      - REDIS_MASTER_PORT_NUMBER=${REDIS_SERVER_PORT}
      - REDIS_MASTER_PASSWORD=${REDIS_SERVER_PASSWORD}
      - REDIS_SENTINEL_PORT_NUMBER=${REDIS_SENTINEL_PORT}
      - REDIS_SENTINEL_QUORUM
      - REDIS_SENTINEL_RESOLVE_HOSTNAMES=yes
    expose:
      - "${REDIS_SENTINEL_PORT}"
    depends_on:
      - master

  haproxy:
    image: "${REDIS_HAPROXY_IMAGE}"
    ports:
      - "${REDIS_HAPROXY_PORT}:${REDIS_SERVER_PORT}"
      - "${REDIS_HAPROXY_STATS_PORT}:${REDIS_HAPROXY_STATS_PORT}"
    environment:
      - REDIS_SERVER_PORT
      - REDIS_HAPROXY_STATS_PORT
      - REDIS_SERVER_PASSWORD
    volumes:
      - type: bind
        source: "./haproxy.cfg"
        target: "/usr/local/etc/haproxy/haproxy.cfg"
        read_only: true
    depends_on:
      - master

networks:
  default:
    name: redis_network
