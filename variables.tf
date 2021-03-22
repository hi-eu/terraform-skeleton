#------------------------------------------------------------------------------
# Variables that need to be set
#------------------------------------------------------------------------------
variable "aws_region" {
  description = "The AWS region to work in"

  type        = string
  default     = "us-east-1"
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

variable "enable_nat_gateway" {
  type = bool
}

variable "enable_vpn_gateway" {
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