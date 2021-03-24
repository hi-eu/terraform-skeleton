#------------------------------------------------------------------------------
# Variables that need to be set
#------------------------------------------------------------------------------
variable "aws_region" {
  description = "The AWS region to work in"

  type        = string
}

variable "tf_project" {
  description = "The name of the project folder that inputs.tfvars is in"

  type        = string
}

variable "environment" {
  type = string
}

variable "cidr" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "database_subnets" {
  type = list(string)
}

variable "create_database_subnet_group" {
  type = bool
}

variable "enable_nat_gateway" {
  type = bool
}

variable "enable_vpn_gateway" {
  type = bool
}

variable "single_nat_gateway" {
  type = bool
}
variable "one_nat_gateway_per_az" {
  type = bool
}

variable "ecr_repositories" {
  description = "List of image names, used as repository names for AWS ECR "

  type = any
}

variable "ecr_namespace" {
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"

  type        = string
  default     = null

}

variable "ecr_delimiter" {
  description = <<-EOT
    Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.
    Defaults to `-` (hyphen). Set to `""` to use no delimiter at all.
  EOT

  type        = string
  default     = "-"
}

variable "ecr_principals_readonly_access" {
  description = "Principal ARNs to provide with readonly access to the ECR"

  type        = list(string)
  default     = []
}

variable "ecr_principals_full_access" {
  description = "Principal ARNs to provide with full access to the ECR"

  type        = list(string)
  default     = []
}

variable "enabled_ssm_parameter_store" {
  type = bool
}

variable "pgrds_allocated_storage" {
  type = number
}
variable "pgrds_max_allocated_storage" {
  type = number
}
variable "pgrds_storage_encrypted" {
  type = bool
}
variable "pgrds_backup_window" {
  type = string
}
variable "pgrds_engine" {
  type = string
}
variable "pgrds_engine_version" {
  type = string
}
variable "pgrds_identifier" {
  type = string
}
variable "pgrds_instance_class" {
  type = string
}
variable "pgrds_maintenance_window" {
  type = string
}
variable "pgrds_port" {
  type = number
}
variable "pgrds_username" {
  type = string
}

variable "pgrds_parameters" {
  type = any
}

variable "pgrds_family" {
  type = string
}

variable "pgrds_create_db_subnet_group" {
  type = bool
}

variable "pgrds_random_password_length" {
  type = number
}