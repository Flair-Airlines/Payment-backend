# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    {
      Name = "${var.vpc_name}-VPC"
    },
    var.tags
  )
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id               = aws_vpc.main.id
  cidr_block           = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone    = var.availability_zone

  tags = merge(
    {
      Name = "${var.vpc_name}-PublicSubnet"
    },
    var.tags
  )
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone

  tags = merge(
    {
      Name = "${var.vpc_name}-PrivateSubnet"
    },
    var.tags
  )
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name = "${var.vpc_name}-IGW"
    },
    var.tags
  )
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    {
      Name = "${var.vpc_name}-Public_RT"
    },
    var.tags
  )
}

# Associate Route Table with Public Subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(
    {
      Name = "${var.vpc_name}-EIP"
    },
    var.tags
  )

}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  depends_on = [aws_internet_gateway.igw]  # Ensures Internet Gateway exists before creating NAT Gateway

  tags = merge(
    {
      Name = "${var.vpc_name}-NAT-Gateway"
    },
    var.tags
  )
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = merge(
    {
      Name = "${var.vpc_name}-Private_RT"
    },
    var.tags
  )
}

# Associate Route Table with Private Subnet
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# DynamoDB VPC Interface Endpoint (PrivateLink)
resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.dynamodb"  # Service name for DynamoDB
  vpc_endpoint_type = "Interface"

  # Define the subnets in which to create the endpoint
  subnet_ids = [
    aws_subnet.private.id  # Use the private subnet for the endpoint
  ]

  # Security Group to allow access to the endpoint
  security_group_ids = [aws_security_group.dynamodb_sg.id]

  tags = merge(
    {
      Name = "${var.vpc_name}-DynamoDBEndpoint"
    },
    var.tags
  )
}

# Security Group for DynamoDB VPC Endpoint
resource "aws_security_group" "dynamodb_sg" {
  vpc_id = aws_vpc.main.id

  # Allow traffic from the private subnet (using the subnet's CIDR block directly)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = "${var.vpc_name}-DynamoDBEndpointSG"
    },
    var.tags
  )
}