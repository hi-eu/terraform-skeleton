#------------------------------------------------------------------------------
# Require Version .12
#------------------------------------------------------------------------------

terraform {
  required_version = ">= 0.12.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

#------------------------------------------------------------------------------
# Local variable
#------------------------------------------------------------------------------

locals {
  tags = {
    Terraform   = "true"
    Owner       = "hieunc"
    Environment = var.environment
    Project     = var.tf_project
  }
}

#------------------------------------------------------------------------------
# VPC
#------------------------------------------------------------------------------


module "vpc" {
  source = "git::git@github.com:hieunc-edu/terraform-aws-vpc.git"

  name = "${var.tf_project}-vpc"
  cidr = var.cidr

  azs                          = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  private_subnets              = var.private_subnets
  public_subnets               = var.public_subnets
  database_subnets             = var.database_subnets
  create_database_subnet_group = var.create_database_subnet_group
  enable_nat_gateway           = var.enable_nat_gateway
  single_nat_gateway           = var.single_nat_gateway
  one_nat_gateway_per_az       = var.one_nat_gateway_per_az
  enable_vpn_gateway           = var.enable_vpn_gateway

  tags = merge(
    local.tags,
    {
      Service = "vpc"
    }
  )
}

#------------------------------------------------------------------------------
# Security Group
#------------------------------------------------------------------------------
module "security_group" {
  source = "git::git@github.com:hieunc-edu/terraform-aws-security-group.git"

  name                = "postgre-sgr"
  description         = "PostgreSQL security group"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  ingress_rules       = ["postgresql-tcp"]

  tags = merge(
    local.tags,
    {
      Service = "secgr"
    }
  )
}

#------------------------------------------------------------------------------
# ECR
#------------------------------------------------------------------------------


module "ecr" {
  source   = "git::git@github.com:hieunc-edu/terraform-aws-ecr"
  for_each = var.ecr_repositories == null ? {} : var.ecr_repositories

  delimiter                  = var.ecr_delimiter
  name                       = each.key
  namespace                  = try(each.value["namespace"], var.ecr_namespace)
  stage                      = try(each.value["stage"], var.environment)
  principals_full_access     = try(each.value["principals_full_access"], var.ecr_principals_full_access)
  principals_readonly_access = try(each.value["principals_readonly_access"], var.ecr_principals_readonly_access)

  tags = merge(
    local.tags,
    {
      Service    = "ecr"
      Repository = each.key
    }
  )
}

#------------------------------------------------------------------------------
# RDS
#------------------------------------------------------------------------------
resource "random_password" "pgadmin" {
  length = 24
}

module "aws_rds_postgres" {
  source = "git::git@github.com:hieunc-edu/terraform-aws-rds.git"

  allocated_storage      = var.pgrds_allocated_storage
  max_allocated_storage  = var.pgrds_max_allocated_storage
  storage_encrypted      = var.pgrds_storage_encrypted
  backup_window          = var.pgrds_backup_window
  engine                 = var.pgrds_engine
  engine_version         = var.pgrds_engine_version
  family                 = var.pgrds_family
  identifier             = var.pgrds_identifier
  instance_class         = var.pgrds_instance_class
  maintenance_window     = var.pgrds_maintenance_window
  port                   = var.pgrds_port
  username               = var.pgrds_username
  password               = random_password.pgadmin.result
  create_random_password = var.pgrds_create_random_password
  random_password_length = var.pgrds_random_password_length
  vpc_security_group_ids = [module.security_group.this_security_group_id]
  subnet_ids             = module.vpc.database_subnets
  parameters             = var.pgrds_parameters
  create_db_subnet_group = var.pgrds_create_db_subnet_group
  db_subnet_group_name   = module.vpc.database_subnet_group_name
  tags = merge(
    local.tags,
    {
      Service = "rds"
    }

  )
}

resource "aws_ssm_parameter" "default_postgres_ssm_parameter_identifier" {
  count = var.enabled_ssm_parameter_store ? 1 : 0

  name  = "/rds/db/${var.pgrds_identifier}/identifier"
  value = var.pgrds_identifier
  type  = "String"

  overwrite = true
}

resource "aws_ssm_parameter" "pg_endpoint" {
  count = var.enabled_ssm_parameter_store ? 1 : 0

  name  = "/rds/db/${var.pgrds_identifier}/endpoint"
  value = module.aws_rds_postgres.this_db_instance_endpoint
  type  = "String"

  overwrite = true
}

resource "aws_ssm_parameter" "pg_username" {
  count = var.enabled_ssm_parameter_store ? 1 : 0

  name  = "/rds/db/${var.pgrds_identifier}/superuser/username"
  value = var.pgrds_username
  type  = "SecureString"

  overwrite = true
}

resource "aws_ssm_parameter" "pg_password" {
  count = var.enabled_ssm_parameter_store ? 1 : 0

  name  = "/rds/db/${var.pgrds_identifier}/superuser/password"
  value = module.aws_rds_postgres.this_db_instance_password
  type  = "SecureString"

  overwrite = true
}

resource "aws_ssm_parameter" "pg_master_password" {
  count = var.enabled_ssm_parameter_store ? 1 : 0

  name  = "/rds/db/${var.pgrds_identifier}/superuser/master-password"
  value = module.aws_rds_postgres.this_db_master_password
  type  = "SecureString"

  overwrite = true
}

#------------------------------------------------------------------------------
# Jenkins
#------------------------------------------------------------------------------

module myip {
  source  = "4ops/myip/http"
  version = "1.0.0"
}

// Bring your own ACM cert for the Application Load Balancer

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> v2.0"

  domain_name = "${var.jenkins_alias_name}.${var.jenkins_domain_name}"
  zone_id     = var.jenkins_domain_name_zone_id

  tags = merge(
    {
      Service = "acm"
    },
    local.tags
  )
}

resource "aws_kms_key" "efs_kms_key" {
  description = "KMS key used to encrypt Jenkins EFS volume"
}

module "jenkins" {
  source                        = "git::git@github.com:hieunc-edu/jenkins-aws-fargate.git"
  alb_subnet_ids                = module.vpc.public_subnets
  efs_subnet_ids                = module.vpc.private_subnets
  vpc_id                        = module.vpc.vpc_id
  name_prefix                   = var.jenkins_name_prefix
  efs_kms_key_arn               = aws_kms_key.efs_kms_key.arn
  jenkins_controller_subnet_ids = module.vpc.private_subnets
  alb_ingress_allow_cidrs       = ["${module.myip.address}/32"]
  alb_acm_certificate_arn       = module.acm.this_acm_certificate_arn
  route53_create_alias          = true
  route53_alias_name            = var.jenkins_alias_name
  route53_zone_id               = var.jenkins_domain_name_zone_id
  tags = merge(
    {
      Service : "ecs"
      Solution : "jenkins"
    },
    local.tags
  )
}
