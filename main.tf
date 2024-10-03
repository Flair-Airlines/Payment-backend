# Call VPC module
module "vpc" {
  source = "./modules/VPC"

  aws_region          = var.aws_region
  vpc_cidr_block      = var.vpc_cidr_block
  vpc_name            = var.vpc_name
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = var.availability_zone
  tags                = var.tags
}

# Call DynamoDB Module
module "dynamodb" {
  source                  = "./modules/DynamoDB" # Path to your module
  
  table_name              = var.table_name
  hash_key                = var.hash_key
  range_key               = var.range_key
  billing_mode            = var.billing_mode
  point_in_time_recovery  = var.point_in_time_recovery
  server_side_encryption  = var.server_side_encryption
  dynamodb_log_group_name = var.dynamodb_log_group_name
  aws_region              = var.aws_region
  tags                    = var.tags
}