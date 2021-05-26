chmox +x entrypoint.sh
mkdir -p data && sudo chown 1001 data
ERLANG cookie warning cannot be disabled
For RabbitMQ I'm using separate blocks for each of replicas due to problems with data persistency.
Also, data folder will contain pidfiles
