

module "cluster" {
  source = "./modules/ecs-cluster"
  env_name = "foo"
  aws_profile = "${var.aws_profile}"
  aws_region = "${var.aws_region}"
}

module "task" {
  source = "./modules/ecs-task"
  env_name = "dev"
  cluster_name = "${module.cluster.cluster_name}"
  name = "test"
  aws_profile = "${var.aws_profile}"
  aws_region = "${var.aws_region}"
}
