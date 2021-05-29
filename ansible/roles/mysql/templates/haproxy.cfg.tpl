global
  presetenv MYSQL_SERVER_PORT 3306
  presetenv MYSQL_HAPROXY_STATS_PORT 33060

defaults MYSQL
  mode tcp
  timeout connect  4s
  timeout server   30s
  timeout client   30s
  option  log-health-checks

frontend stats
  bind  "0.0.0.0:${MYSQL_HAPROXY_STATS_PORT}"
  mode  http
  stats enable
  stats hide-version
  stats realm Haproxy\ Statistics
  stats uri /

frontend mysql
  bind "0.0.0.0:${MYSQL_SERVER_PORT}"
  default_backend mysql

backend mysql
  option tcpka
  option mysql-check user {{ mysql.haproxy.user }}
  balance roundrobin

{% set index_offset = 1 %}
{% for index in (range(index_offset, mysql.server.replicas + index_offset) | list) %}
  server server_{{ index }} "server_{{ index }}:${MYSQL_SERVER_PORT}"
{% endfor %}
