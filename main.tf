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

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

module "bastion" {
  source            = "./modules/ecs-bastion"
  name_prefix       = "bastion"
  cluster_name      = "bastion-cluster"
  task_family       = "bastion-task"
  container_command = ["sleep", "3600"]
}