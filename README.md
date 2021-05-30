# Clusters

This project contains Ansible code for configuring clusters of three applications: MySQL, Redis, RabbitMQ. These clusters are created on a local virtual machine, described using Vargantfile.

Ansible creates the clusters using Docker containers and shows them as linux services. Each cluster runs in its own Docker networks and cannot be accessible from other networks. There is also a haproxy in each network that exposes the service to the outside system. So the main idea is to have an isolated env for each cluster.

## Prerequisites

To change existing or develop new modules the following applications and tools are required:
- python3
- pip3
- ansible
- vagrant
- [pre-commit hooks](https://pre-commit.com/#install)
- ansible-lint

### Pre-commit hooks

Pre-commit hooks are scripts that are used by Git for identifying simple issues before submission to code review. Usually, pre-commit hooks run on every local commit, but also can execute manually.

All of the pre-commit hooks of the current project are described in  [.pre-commit-config.yaml](./.pre-commit-config.yaml) file.

After the installation, make sure that the following commands were run in the root of the project:

``` bash
pre-commit install
```

`ansible-lint` and `terraform_docs` will run during the pre-commit run.

## Vagrant

To create virtual machine you need to run `vagrant up`.
To provision ansible on this virtual machine run `vagrant provision`.

After VM provisioning it is needed to:
- Log into the VM (`vagrant ssh`).
- Get its IP address using `ifconfig` command.
- Check app statistics using the below links in a browser.

### Default links

Redis:
- Cluster: <vm_ip>:6379
- Stats: <vm_ip>:63790

RabbitMQ:
- Cluster: <vm_ip>:5672
- Stats: <vm_ip>:56720

MySQL:
- Cluster: <vm_ip>:3306
- Stats: <vm_ip>:33060
