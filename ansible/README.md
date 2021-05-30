# Ansible

Ansible is an IT automation tool. It can configure systems, deploy software, and orchestrate more advanced IT tasks such as continuous deployments or zero downtime rolling updates.

This Ansible project creates three clusters:
- [MySQL](./roles/mysql/README.md)
- [RabbitMQ](./roles/rabbitmq/README.md)
- [Redis](./roles/redis/README.md)

There is also a [common](./roles/common/README.md) role that installs the necessary dependencies for the system, such as: docker, docker-compose and other packages.

## Main tips

This section will describe the main points on which all clusters are similar.

### All projects are located in one folder
Its path can be found in `home` variable of global ones [here](./group_vars/all).
Use that path to check cluster configurations.

### Each cluster is configured as a linux service.
Ansible configures linux service to easily start and stop applications.
Basically, service goes into the appropriate folder and runs or stops docker-compose there.

The command to call the service is as follows:
`sudo service project@<app_name> start`
E.G.:
`sudo service project@mysql start`

### Each cluster has no access to the outside

They go up in different Docker networks, this is done to isolate applications from each other.
They are accessed by haproxy, which is present in each of the clusters. It balances load and distributes traffic depending on the availability of the servers.
Thus, haproxy acts as a proxy and a balancer at the same time, because no one can access the application directly, and the connection will be as uninterrupted as possible.

Haproxy has the ability to show its stats and the health of the total endpoints. You can view it by calling `port_stats` of each haproxy.

### Variable structure

The variable structure is a bit strange for Ansible practices. I use a block structure of variables to make it easier to understand, but because of that I have to include `hash_behaviour=merge` for `ansible.cfg`, otherwise this variables will be overwritten when the variable changes.
