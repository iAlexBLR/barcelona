version: '3.8'

services:
  rabbitmq_1:
    hostname: rabbitmq_1
    image: "${RABBITMQ_IMAGE}"
    environment:
      - RABBITMQ_DEFAULT_USER
      - RABBITMQ_DEFAULT_PASS
      - RABBITMQ_ERLANG_COOKIE
    volumes: &rabbitmq_data
      - type: bind
        source: "./${RABBITMQ_DATA_FOLDER}"
        target: "/var/lib/rabbitmq/mnesia"

{% set index_offset = 2 %}
{% for index in (range(index_offset, redis.server.replicas + index_offset) | list) %}
{% if index == 2 %}
  rabbitmq_{{ index }}: &node
    hostname: rabbitmq_{{ index }}
    image: "${RABBITMQ_IMAGE}"
    environment:
      - RABBITMQ_DEFAULT_NODE=rabbitmq_1
      - RABBITMQ_ERLANG_COOKIE
    volumes:
      - << : *rabbitmq_data
      - type: bind
        source: ./entrypoint.sh
        target: &entrypoint /usr/local/bin/cluster-entrypoint.sh
        read_only: true
    entrypoint: *entrypoint
    depends_on:
      - rabbitmq_1

{% else %}
  rabbitmq_{{ index }}:
    << : *node
    hostname: rabbitmq_{{ index }}

{% endif %}
{% endfor %}
  haproxy:
    image: "${RABBITMQ_HAPROXY_IMAGE}"
    ports:
      - "${RABBITMQ_HAPROXY_PORT}:${RABBITMQ_NODE_PORT}"
      - "${RABBITMQ_HAPROXY_MANAGEMENT_PORT}:${RABBITMQ_MANAGEMENT_PORT}"
      - "${RABBITMQ_HAPROXY_STATS_PORT}:${RABBITMQ_HAPROXY_STATS_PORT}"
    environment:
      - RABBITMQ_NODE_PORT
      - RABBITMQ_MANAGEMENT_PORT
      - RABBITMQ_HAPROXY_STATS_PORT
    volumes:
      - type: bind
        source: ./haproxy.cfg
        target: /usr/local/etc/haproxy/haproxy.cfg
        read_only: true
    depends_on:
      - rabbitmq_1

networks:
  default:
    name: rabbitmq_network
