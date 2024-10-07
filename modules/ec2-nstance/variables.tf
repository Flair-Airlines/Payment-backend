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