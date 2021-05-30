RabbitMQ
=========

This role creates a RabbitMQ cluster in Docker and a Linux service that manages the cluster behavior.

Requirements
------------

This module haas no requirements.

Role Variables
--------------

Default variables have the following structure:
```
rabbitmq:
  data_folder: folder for storing application data on the system.
  server:
    replicas: rabbitmq replicas count.
    image: rabbitmq docker image.
    port: rabbitmq port.
    port_management: rabbitmq management port.
    user: rabbitmq username.
    password: rabbitmq password.
    erlang_cookie: rabbitmq erlang cookie for attaching into cluster.
  haproxy:
    image: haproxy docker image.
    port: haproxy rabbitmq port.
    port_management: haproxy rabbitmq management port.
    port_stats: haproxy rabbitmq port for statistics.
```

Dependencies
------------

This module has dependency on [common](../common/) module.

Additional tips
---------------

Since I did not find a nice solution to successfully join all containers to the cluster, I decided to change the entrypoint so that on startup the replicas would join the cluster themselves. The details can be found [here](./files/entrypoint.sh).
