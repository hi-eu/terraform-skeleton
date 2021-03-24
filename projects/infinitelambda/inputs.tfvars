#------------------------------------------------------------------------------
# Project
#------------------------------------------------------------------------------

tf_project  = "infinitelambda"
aws_region  = "ap-southeast-1"
environment = "demo"

#------------------------------------------------------------------------------
# Tfstate
#------------------------------------------------------------------------------

tfstate_enabled = true
tfstate_stage   = "ready"
tfstate_name    = "terraform-tfstate-backend"
tfstate_force_destroy = false

#------------------------------------------------------------------------------
# VPC
#------------------------------------------------------------------------------

cidr                         = "10.0.0.0/16"
private_subnets              = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
public_subnets               = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]
database_subnets             = ["10.0.30.0/24", "10.0.31.0/24", "10.0.32.0/24"]
enable_nat_gateway           = true
single_nat_gateway           = false
one_nat_gateway_per_az       = true
enable_vpn_gateway           = false
create_database_subnet_group = true

#------------------------------------------------------------------------------
# ECR
#------------------------------------------------------------------------------

ecr_namespace = "default"
ecr_delimiter = "_"
ecr_repositories = {
  db_info = {
    namespace = "backend", //override ecr_namespace
    stage     = "prod",    // override environment
  }
}

#------------------------------------------------------------------------------
# PG RDS
#------------------------------------------------------------------------------
enabled_ssm_parameter_store  = true
pgrds_allocated_storage      = 10
pgrds_max_allocated_storage  = 50
pgrds_storage_encrypted      = false
pgrds_create_db_subnet_group = false
pgrds_create_random_password = true
pgrds_random_password_length = 32
pgrds_backup_window          = "03:00-06:00"
pgrds_engine                 = "postgres"
pgrds_engine_version         = "12.5"
pgrds_family                 = "postgres12"
pgrds_identifier             = "postgresql"
pgrds_instance_class         = "db.t3.small"
pgrds_maintenance_window     = "Mon:00:00-Mon:03:00"
pgrds_port                   = 5432
pgrds_username               = "pgadmin"
pgrds_parameters = [
  {
    name  = "autovacuum"
    value = 1
  },
  {
    name  = "client_encoding"
    value = "utf8"
  }
]

