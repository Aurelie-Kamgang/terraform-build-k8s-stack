output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

# output "security_group_id" {
#   description = "ID of the security group"
#   value       = aws_security_group.this.id
# }