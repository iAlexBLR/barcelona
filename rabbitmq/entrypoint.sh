#!/usr/bin/env bash

set -eu

docker-entrypoint.sh rabbitmq-server -detached
sleep 5
rabbitmqctl await_startup
rabbitmqctl stop_app
rabbitmqctl join_cluster "rabbit@${RABBITMQ_MASTER}"
rabbitmqctl stop
rabbitmq-server
