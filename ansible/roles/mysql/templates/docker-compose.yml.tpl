version: '3.8'

services:

{% set index_offset = 1 %}
{% for index in (range(index_offset, mysql.mgm.replicas + index_offset) | list) %}
{% if index == 1 %}
  ndb_mgm_{{ index }}: &mgm
    image: "${MYSQL_SERVER_IMAGE}"
    hostname: ndb_mgm_{{ index }}
    command: ["ndb_mgmd"]
    environment:
      - MYSQL_TCP_PORT=${MYSQL_SERVER_PORT}
    volumes:
      - &cluster_cnf
        type: bind
        source: ./mysql-cluster.cnf
        target: /etc/mysql-cluster.cnf
      - &my_cnf
        type: bind
        source: ./my.cnf
        target: /etc/my.cnf
      - type: bind
        source: "./${MYSQL_SERVER_DATA_FOLDER}/ndb_mgm_{{ index }}"
        target: /var/lib/mysql
    networks: &network
      - mysql

{% else %}
  ndb_mgm_{{ index }}:
    << : *mgm
    hostname: ndb_mgm_{{ index }}
    volumes:
      - << : *cluster_cnf
      - << : *my_cnf
      - type: bind
        source: "./${MYSQL_SERVER_DATA_FOLDER}/ndb_mgm_{{ index }}"
        target: /var/lib/mysql

{% endif %}
{% endfor %}
{% set index_offset = 1 %}
{% for index in (range(index_offset, mysql.node.replicas + index_offset) | list) %}
{% if index == 1 %}

  ndb_{{ index }}: &node
    image: "${MYSQL_SERVER_IMAGE}"
    hostname: ndb_{{ index }}
    command: ["ndbd"]
    environment:
      - MYSQL_TCP_PORT=${MYSQL_SERVER_PORT}
    volumes:
      - << : *cluster_cnf
      - << : *my_cnf
      - type: bind
        source: "./${MYSQL_SERVER_DATA_FOLDER}/ndb_{{ index }}"
        target: /var/lib/mysql
    networks: *network

{% else %}

  ndb_{{ index }}:
    << : *node
    hostname: ndb_{{ index }}
    volumes:
      - << : *cluster_cnf
      - << : *my_cnf
      - type: bind
        source: "./${MYSQL_SERVER_DATA_FOLDER}/ndb_{{ index }}"
        target: /var/lib/mysql

{% endif %}
{% endfor %}
{% for index in (range(index_offset, mysql.server.replicas + index_offset) | list) %}
{% if index == 1 %}

  server_{{ index }}: &mysql
    image: "${MYSQL_SERVER_IMAGE}"
    hostname: server_{{ index }}
    command: ["mysqld"]
    environment:
      - MYSQL_TCP_PORT=${MYSQL_SERVER_PORT}
      - MYSQL_USER=${MYSQL_SERVER_USER}
      - MYSQL_PASSWORD=${MYSQL_SERVER_PASSWORD}
      - MYSQL_ROOT_PASSWORD=${MYSQL_SERVER_ROOT_PASSWORD}
      - MYSQL_ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - << : *cluster_cnf
      - << : *my_cnf
    networks: *network

{% else %}

  server_{{ index }}:
    << : *mysql
    hostname: server_{{ index }}

{% endif %}
{% endfor %}
  haproxy:
    image: "${MYSQL_HAPROXY_IMAGE}"
    ports:
      - "${MYSQL_HAPROXY_PORT}:${MYSQL_SERVER_PORT}"
      - "${MYSQL_HAPROXY_STATS_PORT}:${MYSQL_HAPROXY_STATS_PORT}"
    environment:
      - MYSQL_SERVER_PORT
      - MYSQL_HAPROXY_STATS_PORT
    volumes:
      - type: bind
        source: ./haproxy.cfg
        target: /usr/local/etc/haproxy/haproxy.cfg
        read_only: true
    networks: *network

networks:
  mysql:
    name: mysql_network
