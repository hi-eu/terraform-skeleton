#------------------------------------------------------------------------------
# Require Version .12
#------------------------------------------------------------------------------
terraform {
  required_version = ">= 0.12.0"
}

#------------------------------------------------------------------------------
# VPC
#------------------------------------------------------------------------------

module "vpc" {
  source = "git@github.com:hieunc-edu/terraform-aws-vpc.git"

  name = "${var.tf_project}-vpc"
  cidr = var.cidr

  azs             = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  database_subnets = var.database_subnets

  enable_nat_gateway = var.enable_nat_gateway
  enable_vpn_gateway = var.enable_vpn_gateway

  tags = {
    Terraform = "true"
    Environment = var.environment
    Project = var.tf_project
  }
}

#------------------------------------------------------------------------------
# ECR
#------------------------------------------------------------------------------


module "ecr" {
  source    = "git::git@github.com:hieunc-edu/terraform-aws-ecr"
  for_each  = var.ecr_repositories == null ?{}: var.ecr_repositories

  delimiter = var.ecr_delimiter
  name      = each.key
  namespace = try(each.value["namespace"], var.ecr_namespace)
  stage     = try(each.value["stage"], var.environment)
  principals_full_access = try(each.value["principals_full_access"], var.ecr_principals_full_access)
  principals_readonly_access = try(each.value["principals_readonly_access"], var.ecr_principals_readonly_access)

  tags = {
    Terraform = "true"
    Environment = var.environment
    Project = var.tf_project
    Service = "ecr"
    repository = each.key
  }
}

