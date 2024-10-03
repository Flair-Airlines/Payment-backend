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
  default     = "PAY_PER_REQUEST"
}

variable "point_in_time_recovery" {
  description = "Enable point-in-time recovery for DynamoDB."
  type        = bool
  default     = true
}

variable "server_side_encryption" {
  description = "Enable server-side encryption for DynamoDB."
  type        = bool
  default     = true
}

variable "dynamodb_log_group_name" {
  description = "Name for the CloudWatch log group for DynamoDB logs."
  type        = string
}

variable "aws_region" {
  description = "The AWS region."
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to resources."
  type        = map(string)
  default     = {}
}