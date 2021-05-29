# Rabbitmq env variables for docker-compose file

RABBITMQ_IMAGE={{ rabbitmq.server.image  }}
RABBITMQ_NODE_PORT={{ rabbitmq.server.port  }}
RABBITMQ_MANAGEMENT_PORT={{ rabbitmq.server.port_management  }}
RABBITMQ_DATA_FOLDER={{ rabbitmq.data_folder }}

RABBITMQ_DEFAULT_USER={{ rabbitmq.server.user  }}
RABBITMQ_DEFAULT_PASS={{ rabbitmq.server.password  }}
RABBITMQ_ERLANG_COOKIE={{ rabbitmq.server.erlang_cookie  }}

RABBITMQ_HAPROXY_IMAGE={{ rabbitmq.haproxy.image  }}
RABBITMQ_HAPROXY_PORT={{ rabbitmq.haproxy.port  }}
RABBITMQ_HAPROXY_MANAGEMENT_PORT={{ rabbitmq.haproxy.port_management  }}
RABBITMQ_HAPROXY_STATS_PORT={{ rabbitmq.haproxy.port_stats  }}
