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

variable "pgrds_create_random_password" {
  type = bool
}

variable "pgrds_random_password_length" {
  type = number
}

variable "tfstate_enabled" {
  type        = bool
  default     = null
  description = "Set to false to prevent the module from creating any resources"
}

variable "tfstate_namespace" {
  type        = string
  default     = null
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
}

variable "tfstate_stage" {
  type        = string
  default     = null
  description = "Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
}

variable "tfstate_name" {
  type        = string
  default     = null
  description = "Solution name, e.g. 'app' or 'jenkins'"
}

variable "tfstate_delimiter" {
  type        = string
  default     = null
  description = <<-EOT
    Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.
    Defaults to `-` (hyphen). Set to `""` to use no delimiter at all.
  EOT
}

variable "tfstate_attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tfstate_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
}

variable "additional_tag_map" {
  type        = map(string)
  default     = {}
  description = "Additional tags for appending to tags_as_list_of_maps. Not added to `tags`."
}

variable "label_order" {
  type        = list(string)
  default     = null
  description = <<-EOT
    The naming order of the id output and Name tag.
    Defaults to ["namespace", "environment", "stage", "name", "attributes"].
    You can omit any of the 5 elements, but at least one must be present.
  EOT
}

variable "regex_replace_chars" {
  type        = string
  default     = null
  description = <<-EOT
    Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.
    If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits.
  EOT
}

variable "id_length_limit" {
  type        = number
  default     = null
  description = <<-EOT
    Limit `id` to this many characters (minimum 6).
    Set to `0` for unlimited length.
    Set to `null` for default, which is `0`.
    Does not affect `id_full`.
  EOT
  validation {
    condition     = var.id_length_limit == null ? true : var.id_length_limit >= 6 || var.id_length_limit == 0
    error_message = "The id_length_limit must be >= 6 if supplied (not null), or 0 for unlimited length."
  }
}

variable "label_key_case" {
  type        = string
  default     = null
  description = <<-EOT
    The letter case of label keys (`tag` names) (i.e. `name`, `namespace`, `environment`, `stage`, `attributes`) to use in `tags`.
    Possible values: `lower`, `title`, `upper`.
    Default value: `title`.
  EOT

  validation {
    condition     = var.label_key_case == null ? true : contains(["lower", "title", "upper"], var.label_key_case)
    error_message = "Allowed values: `lower`, `title`, `upper`."
  }
}

variable "label_value_case" {
  type        = string
  default     = null
  description = <<-EOT
    The letter case of output label values (also used in `tags` and `id`).
    Possible values: `lower`, `title`, `upper` and `none` (no transformation).
    Default value: `lower`.
  EOT

  validation {
    condition     = var.label_value_case == null ? true : contains(["lower", "title", "upper", "none"], var.label_value_case)
    error_message = "Allowed values: `lower`, `title`, `upper`, `none`."
  }
}

variable "tfstate_force_destroy" {
  type = bool
}

variable "jenkins_domain_name_zone_id" {
  type = string
}

variable "jenkins_alias_name" {
  type = string
}

variable "jenkins_name_prefix" {
  type = string
}

variable "jenkins_domain_name" {
  type = string
}