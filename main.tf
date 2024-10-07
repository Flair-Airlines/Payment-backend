# Call VPC module
module "vpc" {
  source = "./modules/vpc" # Path to your module

  vpc_name            = var.vpc_name
  aws_region          = var.aws_region
  vpc_cidr_block      = var.vpc_cidr_block
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = var.availability_zone
  tags                = var.tags
}

# Call DynamoDB Module
module "dynamodb" {
  source = "./modules/dynamodb" # Path to your module

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

# call ec2-instance module
module "ec2-instance" {
  source = "./modules/ec2-instance" # Path to your EC2 module

  vpc_name            = var.vpc_name
  vpc_id              = module.vpc.vpc_id
  public_subnet_id    = module.vpc.public_subnet_id
  ssh_cidr_block      = var.ssh_cidr_block      # SSH CIDR block from your .tfvars
  ami_name            = var.ami_name            # AMI name from your .tfvars
  public_key_location = var.public_key_location # Public key location from your .tfvars
  instance_type       = var.instance_type       # Instance type from your .tfvars

}