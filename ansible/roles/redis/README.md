Redis
=========

This role creates a Redis cluster in Docker and a Linux service that manages the cluster behavior.

Requirements
------------

This module haas no requirements.

Role Variables
--------------

Default variables have the following structure:
```
redis:
  data_folder: folder for storing application data on the system.
  server:
    replicas: redis replicas count.
    image: redis docker image.
    port: redis port.
    password: redis password.
  sentinel:
    replicas: redis sentinel replicas count.
    image: redis sentinel docker image.
    port: redis sentinel port.
    quorum: redis sentinel quorum number.
  haproxy:
    image: haproxy docker image.
    port: haproxy redis port.
    port_stats: haproxy redis port for statistics.
```

Dependencies
------------

This module has dependency on [common](../common/) module.

Additional tips
---------------

The haproxy of this cluster has a peculiarity: other haproxys show the availability of the endpoints and the ideal situation is when all of them are available, while this redis haproxy shows the current cluster master and switches in case of failover. So don't be surprised when you find that only one redis server is up and ready.
