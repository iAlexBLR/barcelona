# Redis env variables for docker-compose file

REDIS_SERVER_IMAGE={{ redis.server.image }}
REDIS_SERVER_PORT={{ redis.server.port }}
REDIS_SERVER_PASSWORD={{ redis.server.password }}
REDIS_SERVER_DATA_FOLDER={{ redis.data_folder }}

REDIS_SENTINEL_IMAGE={{ redis.sentinel.image }}
REDIS_SENTINEL_PORT={{ redis.sentinel.port }}
REDIS_SENTINEL_QUORUM={{ redis.sentinel.quorum }}
REDIS_SENTINEL_REPLICAS={{ redis.sentinel.replicas }}

REDIS_HAPROXY_IMAGE={{ redis.haproxy.image }}
REDIS_HAPROXY_PORT={{ redis.haproxy.port }}
REDIS_HAPROXY_STATS_PORT={{ redis.haproxy.port_stats }}
