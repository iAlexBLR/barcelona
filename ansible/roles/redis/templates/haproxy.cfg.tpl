global
  presetenv REDIS_SERVER_PORT 6379
  presetenv REDIS_HAPROXY_STATS_PORT 63790

defaults REDIS
  mode tcp
  timeout connect  4s
  timeout server   30s
  timeout client   30s

frontend stats
  bind  "0.0.0.0:${REDIS_HAPROXY_STATS_PORT}"
  mode  http
  stats enable
  stats hide-version
  stats realm Haproxy\ Statistics
  stats uri /

frontend redis
  bind "0.0.0.0:${REDIS_SERVER_PORT}"
  default_backend redis

backend redis
  option    tcp-check
  tcp-check connect
  tcp-check send AUTH\ "${REDIS_SERVER_PASSWORD}"\r\n
  tcp-check send PING\r\n
  tcp-check expect string +PONG
  tcp-check send info\ replication\r\n
  tcp-check expect string role:master
  tcp-check send QUIT\r\n
  tcp-check expect string +OK

{% set index_offset = 1 %}
{% set total = redis.server.replicas + 1 %}
{% for index in (range(index_offset, total + index_offset) | list) %}
  server redis_{{ index }} "redis_{{ index }}:${REDIS_SERVER_PORT}" check inter 1s
{% endfor %}
