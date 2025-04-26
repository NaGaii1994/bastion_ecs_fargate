variable "name_prefix" {
  description = "Prefix for naming"
  type        = string
}

variable "cluster_name" {
  description = "ECS Cluster Name"
  type        = string
}

variable "task_family" {
  description = "Task Family Name"
  type        = string
}

variable "cpu" {
  description = "Fargate CPU units"
  type        = string
  default     = "256"
}

variable "memory" {
  description = "Fargate Memory"
  type        = string
  default     = "512"
}

variable "container_image" {
  description = "Container image to run"
  type        = string
}

variable "container_command" {
  description = "Command to run inside container"
  type        = list(string)
}