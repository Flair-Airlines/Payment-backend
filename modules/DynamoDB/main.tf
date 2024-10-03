# Fetch the current AWS account details
data "aws_caller_identity" "current" {}

# S3 Bucket to store audit logs
resource "aws_s3_bucket" "dynamodb_audit_logs" {
  bucket = "${var.table_name}-audit-logs"
}

# Remove the block public access settings (allow public access)
resource "aws_s3_bucket_public_access_block" "dynamodb_audit_logs_block" {
  bucket = aws_s3_bucket.dynamodb_audit_logs.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# S3 Bucket Policy for logging
resource "aws_s3_bucket_policy" "dynamodb_audit_logs_policy" {
  bucket = aws_s3_bucket.dynamodb_audit_logs.bucket
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.dynamodb_audit_logs.arn}/*"  # Ensure this ARN is correct
      }
    ]
  })
}

# DynamoDB Table
resource "aws_dynamodb_table" "my_dynamodb_table" {
  name         = var.table_name
  billing_mode = var.billing_mode
  hash_key     = var.hash_key

  # Define the hash key attribute
  attribute {
    name = var.hash_key
    type = "S"
  }

  # Define the range key dynamically if it exists
  dynamic "attribute" {
    for_each = var.range_key != null ? [var.range_key] : []
    content {
      name = var.range_key
      type = "S"
    }
  }

  # Define the `create_at` attribute
  attribute {
    name = "create_at"
    type = "S"
  }

  # Enable deletion protection
  deletion_protection_enabled = false
  
  # Global Secondary Index (GSI) to index the `create_at` attribute
  global_secondary_index {
    name            = "CreateAtIndex"
    hash_key        = "create_at"
    projection_type = "ALL"
    write_capacity  = 1
    read_capacity   = 1
  }

  point_in_time_recovery {
    enabled = var.point_in_time_recovery
  }

  server_side_encryption {
    enabled = var.server_side_encryption
  }

  tags = merge(
    {
      Name = var.table_name
    },
    var.tags
  )
}