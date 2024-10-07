# VPC Configuration
variable "aws_region" {
  type        = string
  description = "The AWS region to deploy resources in"
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

# DynamoDB Configuration
variable "table_name" {
  description = "The name of the DynamoDB table."
  type        = string
}

variable "hash_key" {
  description = "The hash key for the DynamoDB table."
  type        = string
}

variable "range_key" {
  description = "The range key for the DynamoDB table (optional)."
  type        = string
  default     = null
}

variable "billing_mode" {
  description = "The billing mode for DynamoDB (PAY_PER_REQUEST or PROVISIONED)."
  type        = string
}

variable "point_in_time_recovery" {
  description = "Enable point-in-time recovery for DynamoDB."
  type        = bool
}

variable "server_side_encryption" {
  description = "Enable server-side encryption for DynamoDB."
  type        = bool
}

variable "dynamodb_log_group_name" {
  description = "Name for the CloudWatch log group for DynamoDB logs."
  type        = string
}

#ec2-instance configuration
variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnet_id" {
  description = "The ID of the public subnet for the EC2 instance"
  type        = string
}

variable "ssh_cidr_block" {
  description = "CIDR block for SSH access"
  type        = string
}

variable "ami_name" {
  description = "The name pattern for the AMI"
  type        = string
}

variable "public_key_location" {
  description = "Path to the public SSH key"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance"
  type        = string
}

variable "vpc_name" {
  description = "Prefix for resource names"
  type        = string
}

# common
variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
}

#Project Name
variable "project_name" {
  description = " Name of the project"
  type        = string
}