[Unit]
Description=%i service using local docker compose project
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=true
WorkingDirectory={{ global.home }}/%i
ExecStart={{ common.docker_compose.location }} up -d --remove-orphans
ExecStop={{ common.docker_compose.location }} down --remove-orphans

[Install]
WantedBy=multi-user.target
