global
  presetenv RABBITMQ_NODE_PORT          5672
  presetenv RABBITMQ_MANAGEMENT_PORT    15672
  presetenv RABBITMQ_HAPROXY_STATS_PORT 56720

defaults RABBITMQ
  mode    tcp
  balance roundrobin
  timeout connect    4s
  timeout server     30s
  timeout client     30s

frontend stats
  bind  "0.0.0.0:${RABBITMQ_HAPROXY_STATS_PORT}"
  mode  http
  stats enable
  stats hide-version
  stats realm Haproxy\ Statistics
  stats uri /

frontend rabbitmq
  bind "0.0.0.0:${RABBITMQ_NODE_PORT}"
  default_backend rabbitmq

frontend rabbitmq_management
  bind "0.0.0.0:${RABBITMQ_MANAGEMENT_PORT}"
  default_backend rabbitmq_management

{% set index_offset = 1 %}
{% set total = rabbitmq.server.replicas + 1 %}
backend rabbitmq
{% for index in (range(index_offset, total + index_offset) | list) %}
  server rabbitmq_{{ index }} "rabbitmq_{{ index }}:${RABBITMQ_NODE_PORT}" check inter 1s
{% endfor %}

backend rabbitmq_management
{% for index in (range(index_offset, total + index_offset) | list) %}
  server rabbitmq_{{ index }} "rabbitmq_{{ index }}:${RABBITMQ_MANAGEMENT_PORT}" check inter 1s
{% endfor %}
