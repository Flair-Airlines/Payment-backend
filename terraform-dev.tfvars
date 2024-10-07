#Project Name
project_name = "payment_gateway"

# VPC Configuration

# Specify the AWS region
aws_region = "ca-central-1"

# vpc name
vpc_name = "audit-infra"

# CIDR block for the VPC
vpc_cidr_block = "10.0.0.0/16"

# CIDR block for the public subnet
public_subnet_cidr = "10.0.1.0/24"

# CIDR block for the private subnet
private_subnet_cidr = "10.0.2.0/24"

# Availability zone for the subnets
availability_zone = "ca-central-1a"

# Tag values for AWS resources
tags = {
  Environment = "Development"
  Project     = "Payment Gateway"
  Owner       = "Anudeep"
}

# DynamoDB Configuration

# Name of the DynamoDB Table
table_name = "my-dynamodb-table"

# Hash key
hash_key = "id"

# The range key for the DynamoDB table
range_key = "create_at"

# The billing mode for DynamoDB (PAY_PER_REQUEST or PROVISIONED)
billing_mode = "PAY_PER_REQUEST"

# Name for the CloudWatch log group for DynamoDB logs
dynamodb_log_group_name = "dynamodb-log-group"

# Enable point-in-time recovery for DynamoDB
point_in_time_recovery = "true"

# Enable server-side encryption for DynamoDB.
server_side_encryption = "true"

#ec2-instance configuration

# SSH CIDR Block
ssh_cidr_block = "0.0.0.0/0" # Our laptop public ip

# AMI Name
ami_name = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" # Example AMI name pattern

# Public Key Location
public_key_location = "./modules/ec2-instance/public_key.pem" # Update with your public key path

# Instance Type
instance_type = "t2.micro" # Specify your instance type

#vpc_id
vpc_id = "./modules/vpc/vpc_id"

#public_subnet_id
public_subnet_id = "./modules/vpc/public_subnet_id"