make entrypoint.sh executable

RABBITMQ_ERLANG_COOKIE env variable support is deprecated and will be REMOVED in a future version. Use the $HOME/.erlang.cookie file or the --erlang-cookie switch instead.

      - ./rabbitmq/data:/var/lib/rabbitmq/mnesia/rabbit@my-rabbit
