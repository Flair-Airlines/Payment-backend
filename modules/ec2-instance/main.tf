# main.tf in EC2 Module

resource "aws_security_group" "sg" {
  name        = "${var.vpc_name}-SG"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id  # Reference the VPC ID passed from the main module

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr_block]  # Reference the CIDR block for SSH access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }

  tags = {
    Name = "${var.vpc_name}-SG"
  }
}

data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = [var.ami_name]  # Reference AMI name pattern from variables
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "ssh-key" {
  key_name   = "server-key"
  public_key = file(var.public_key_location)  # Reference public key location from variables
}

resource "aws_instance" "audit-server" {
  ami                   = data.aws_ami.latest-amazon-linux-image.id
  instance_type         = var.instance_type
  subnet_id             = var.public_subnet_id  # Reference public subnet ID passed from the main module
  vpc_security_group_ids = [aws_security_group.sg.id]

  associate_public_ip_address = true
  key_name                   = aws_key_pair.ssh-key.key_name

  tags = {
    Name = "${var.vpc_name}-server"
  }
}