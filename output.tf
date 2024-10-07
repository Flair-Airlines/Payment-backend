# Outputs from the VPC Module
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = module.vpc.private_subnet_id
}

output "dynamodb_vpc_endpoint_id" {
  description = "The ID of the DynamoDB VPC Endpoint."
  value       = module.vpc.dynamodb_vpc_endpoint_id
}

output "dynamodb_security_group_id" {
  description = "The ID of the security group for the DynamoDB VPC Endpoint."
  value       = module.vpc.dynamodb_security_group_id
}

# Outputs from the DynamoDB Module
output "dynamodb_table_name" {
  description = "The name of the DynamoDB table"
  value       = module.dynamodb.dynamodb_table_name
}

output "dynamodb_table_arn" {
  description = "The ARN of the DynamoDB table"
  value       = module.dynamodb.dynamodb_table_arn
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket for CloudTrail logs"
  value       = module.dynamodb.s3_bucket_name
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket for CloudTrail logs"
  value       = module.dynamodb.s3_bucket_arn
}

#Outputs from the ec2-instance module
output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = module.ec2-instance.instance_id
}

output "public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = module.ec2-instance.public_ip
}