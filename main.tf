terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-northeast-1"
}

module "bastion" {
  source            = "./modules/ecs-bastion"
  name_prefix       = "bastion"
  cluster_name      = "bastion-cluster"
  task_family       = "bastion-task"
  container_image   = "amazonlinux:2"
  container_command = ["sleep", "3600"]
}