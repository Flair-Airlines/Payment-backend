
# Specify the AWS region
aws_region = "ca-central-1"

# CIDR block for the VPC
vpc_cidr_block = "10.0.0.0/16"

# CIDR block for the public subnet
public_subnet_cidr = "10.0.1.0/24"

# CIDR block for the private subnet
private_subnet_cidr = "10.0.2.0/24"

# Availability zone for the subnets
availability_zone = "ca-central-1a"

# Name of the DynamoDB Table
table_name = "my-dynamodb-table"

# hash key
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

# Tag values for AWS resources
tags = {
  Environment = "Development"
  Project     = "Payment Gateway"
  Owner       = "Anudeep"
}
