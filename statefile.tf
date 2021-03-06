module "this" {
  source  = "cloudposse/label/null"
  version = "0.24.1" # requires Terraform >= 0.13.0

  enabled             = var.tfstate_enabled
  namespace           = var.project
  environment         = var.environment
  name                = var.tfstate_name
  delimiter           = var.tfstate_delimiter
  attributes          = var.tfstate_attributes
  tags                = var.tfstate_tags
  additional_tag_map  = var.additional_tag_map
  label_order         = var.label_order
  regex_replace_chars = var.regex_replace_chars
  id_length_limit     = var.id_length_limit
  label_key_case      = var.label_key_case
  label_value_case    = var.label_value_case

  context = var.context
}

variable "context" {
  type = any
  default = {
    enabled             = true
    namespace           = null
    environment         = null
    stage               = null
    name                = null
    delimiter           = null
    attributes          = []
    tags                = {}
    additional_tag_map  = {}
    regex_replace_chars = null
    label_order         = []
    id_length_limit     = null
    label_key_case      = null
    label_value_case    = null
  }
  description = <<-EOT
    Single object for setting entire context at once.
    See description of individual variables for details.
    Leave string and numeric variables as `null` to use default value.
    Individual variable settings (non-null) override settings in context object,
    except for attributes, tags, and additional_tag_map, which are merged.
  EOT

  validation {
    condition     = lookup(var.context, "label_key_case", null) == null ? true : contains(["lower", "title", "upper"], var.context["label_key_case"])
    error_message = "Allowed values: `lower`, `title`, `upper`."
  }

  validation {
    condition     = lookup(var.context, "label_value_case", null) == null ? true : contains(["lower", "title", "upper", "none"], var.context["label_value_case"])
    error_message = "Allowed values: `lower`, `title`, `upper`, `none`."
  }
}

module "tfstate_backend" {
  source = "git::git@github.com:hieunc-edu/terraform-aws-tfstate-backend.git"

  force_destroy                      = var.tfstate_force_destroy
  terraform_backend_config_file_path = "."
  terraform_backend_config_file_name = "${var.project}-${var.environment}-backend.tf"
  context                            = module.this.context
}
