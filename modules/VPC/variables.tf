variable "vpc_name" {
  description = "Prefix for resource names"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
}

variable "availability_zone" {
  description = "The availability zone for the subnets"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
}

variable "aws_region" {
  type        = string
  description = "The AWS region to deploy resources in"
}

output "dynamodb_vpc_endpoint_id" {
  description = "The ID of the DynamoDB VPC Endpoint."
  value       = aws_vpc_endpoint.dynamodb.id
}

output "dynamodb_security_group_id" {
  description = "The ID of the security group for the DynamoDB VPC Endpoint."
  value       = aws_security_group.dynamodb_sg.id
}