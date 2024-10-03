output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}

output "dynamodb_vpc_endpoint_id" {
  description = "The ID of the DynamoDB VPC Endpoint."
  value       = aws_vpc_endpoint.dynamodb.id
}

output "dynamodb_security_group_id" {
  description = "The ID of the security group for the DynamoDB VPC Endpoint."
  value       = aws_security_group.dynamodb_sg.id
}