Common
=========

This module installs the necessary dependencies for future clusters and prepares the folder for the project.

Requirements
------------

This module haas no requirements.

Role Variables
--------------

Default variables have the following structure:
```
common:
  locale: default locale for the VM.
  timezone: default timezone for the VM.
  docker_compose:
    version: docker-compose version to install.
    location: docker-compose binary location.
```

Dependencies
------------

This module has no dependencies.

Additional tips
---------------

Since all clusters are created in the same scenario, namely using docker-compose, it was decided to create a basic structure of the service file and connect it depending on the cluster required.
Therefore, in the service [template](./templates/service.tpl) there is a variable `%i`, which is responsible for the cluster name. Depending on this variable, the service goes into the desired folder and starts the desired project.
