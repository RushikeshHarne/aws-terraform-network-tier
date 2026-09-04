output "vpc_id" {
  description = "The ID of the provisioned VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = aws_subnet.private.id
}

output "discovered_central_bucket" {
  description = "Central S3 bucket dynamically discovered from Repo 1 SSM Parameter"
  value       = data.aws_ssm_parameter.central_state_bucket.value
}
