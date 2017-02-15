# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

## ECS

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.env_name}-windows-services"
}


data "template_file" "user_data" {
  template = "${file("${path.module}/user_data.tpl")}"
  vars {
    cluster_name = "${aws_ecs_cluster.ecs_cluster.name}"

  }
}



