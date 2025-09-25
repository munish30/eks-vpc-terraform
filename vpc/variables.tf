variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

locals {
  cidr_range      = "10.16.0.0/16"
  subnets         = [for cidr in range(8) : cidrsubnet(local.cidr_range, 5, cidr)]
  public_subnets  = slice(local.subnets, 0, 2)
  private_subnets = slice(local.subnets, 2, length(local.subnets))
}

variable "cluster_name" {
  description = "Name of the cluster for tagging"
  type        = string
  default     = "eks-lab-tf"
}
