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

//output "jenkins_master_alb_id" {
//  description = "Jenkins Master Application Load Balancer ID"
//  value       = module.jenkins.aws_lb_lb_id
//}
//
//output "jenkins_master_alb_arn" {
//  description = "Jenkins Master Application Load Balancer ARN"
//  value       = module.jenkins.aws_lb_lb_arn
//}
//
//output "jenkins_master_alb_arn_suffix" {
//  description = "Jenkins Master Application Load Balancer ARN Suffix"
//  value       = module.jenkins.aws_lb_lb_arn_suffix
//}
//
output "jenkins_master_alb_dns_name" {
  description = "Jenkins Master Application Load Balancer DNS Name"
  value       = module.jenkins.lb_dns_name
}
//
//output "jenkins_master_alb_zone_id" {
//  description = "Jenkins Master Application Load Balancer Zone ID"
//  value       = module.jenkins.aws_lb_lb_zone_id
//}