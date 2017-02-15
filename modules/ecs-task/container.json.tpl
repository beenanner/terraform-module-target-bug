
[
    {
      "name": "${env_name}-${name}-task-def",
      "cpu": ${container_cpu},
      "image": "${image}",
      "memory": ${container_memory},
      "networkMode": "nat",
      "portMappings": [
        {
          "hostPort": ${host_port},
          "containerPort": ${container_port},
          "protocol": "tcp"
        }
      ],
      "essential": true,

    ]
  }
]


