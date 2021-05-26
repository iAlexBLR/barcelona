#!/usr/bin/env bash

set -eu

docker-entrypoint.sh rabbitmq-server -detached
sleep 10
rabbitmqctl await_startup
rabbitmqctl stop_app
rabbitmqctl join_cluster "rabbit@${RABBITMQ_DEFAULT_NODE}"
rabbitmqctl stop
rabbitmq-server
