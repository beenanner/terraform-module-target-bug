provider aws {
  profile = "${var.aws_profile}"
  region = "${var.aws_region}"
}

data "template_file" "container" {
  template = "${file("${path.module}/container.json.tpl")}"

  vars {
    aws_account              = "${var.aws_profile}"
    aws_region               = "${var.aws_region}"
    env_name                 = "${var.env_name}"
    name                     = "${var.name}"
    container_cpu            = "${var.container_cpu}"
    container_memory         = "${var.container_memory}"
    container_port           = "${var.container_port}"
    host_port                = "0"
    image                    = "nginx"
  }
}

## task specifics

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.env_name}-${var.name}-task"
  cluster         = "${var.cluster_name}"
  task_definition = "${aws_ecs_task_definition.TaskDefinition.family}:${max("${aws_ecs_task_definition.TaskDefinition.revision}","${data.aws_ecs_task_definition.TaskDefinition.revision}")}"
  desired_count   = 1
}

data "aws_ecs_task_definition" "TaskDefinition" {
  task_definition = "${aws_ecs_task_definition.TaskDefinition.family}"
}

resource "aws_ecs_task_definition" "TaskDefinition" {
  family                = "${var.env_name}_${var.name}"
  container_definitions = "${data.template_file.container.rendered}"
}
