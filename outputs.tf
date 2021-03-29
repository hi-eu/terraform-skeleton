#------------------------------------------------------------------------------
# Outputs tfstate_backend
#------------------------------------------------------------------------------
output "s3_bucket_id" {
  value       = module.tfstate_backend.s3_bucket_id
  description = "S3 bucket ID"
}

output "dynamodb_table_name" {
  value       = module.tfstate_backend.dynamodb_table_name
  description = "DynamoDB table name"
}

output "dynamodb_table_id" {
  value       = module.tfstate_backend.dynamodb_table_id
  description = "DynamoDB table ID"
}

output "jenkins_master_alb_dns_name" {
  description = "Jenkins Master Application Load Balancer DNS Name"
  value       = module.jenkins.lb_dns_name
}

output "statics_cname" {
  value = module.statics_cdn.aliases
}

output "cf_domain" {
  value = module.statics_cdn.cf_domain_name
}

output "Jenkins_EC2_Agent" {
  value = module.ec2_cluster.private_ip
}