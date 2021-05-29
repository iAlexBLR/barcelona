# MySQL env variables for docker-compose file

MYSQL_SERVER_IMAGE={{ mysql.server.image }}
MYSQL_SERVER_PORT={{ mysql.server.port }}
MYSQL_SERVER_USER={{ mysql.server.user }}
MYSQL_SERVER_PASSWORD={{ mysql.server.password }}
MYSQL_SERVER_ROOT_PASSWORD={{ mysql.server.password_root }}
MYSQL_SERVER_DATA_FOLDER={{ mysql.data_folder }}

MYSQL_HAPROXY_IMAGE={{ mysql.haproxy.image }}
MYSQL_HAPROXY_PORT={{ mysql.haproxy.port  }}
MYSQL_HAPROXY_STATS_PORT={{ mysql.haproxy.port_stats }}
