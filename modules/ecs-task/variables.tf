variable "container_cpu" {
  default = "256"
}
variable "container_memory" {
  default = "256"
}
variable "container_port" {
  default = "256"
}

variable "name" {}

variable "env_name" {
  default = "test"
}
variable "cluster_name" { }
variable "aws_region" {
  description = "The AWS region to create things in."
}

variable "aws_profile" {
  description = "The AWS region to create things in."
}

