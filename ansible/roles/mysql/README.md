MySQL
=========

This role creates a MySQL cluster in Docker and a Linux service that manages the cluster behavior.

Requirements
------------

This module haas no requirements.

Role Variables
--------------

Default variables have the following structure:
```
mysql:
  data_folder: folder for storing application data on the system.
  server:
    replicas: mysql server (api) replicas count.
    image: mysql server docker image.
    port: mysql server port.
    user: mysql server default username.
    password: mysql server default password.
    password_root: mysql server root default password.
  node:
    replicas: mysql node servers count.
  mgm:
    replicas: mysql management servers count.
  haproxy:
    image: haproxy docker image.
    port: haproxy mysql port.
    port_stats: haproxy mysql port for statistics.
    user: mysql user for haproxy health checks.
```

Dependencies
------------

This module has dependency on [common](../common/) module.

Additional tips
---------------

In order for haproxy to be able to check the status of the mysql cluster, a user without a password must be created in the servers. This is done by the fact that when you start the servers in the init folder thrown a [file](./templates/create_user.sql.tpl) with a script to create the user.
