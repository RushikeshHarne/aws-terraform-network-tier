# 1. Dynamically discover the central bucket name from SSM Parameter Store (Repo 1)
data "aws_ssm_parameter" "central_state_bucket" {
  name = "/terraform/remote_state_bucket"
}

# 2. Main VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
    ManagedBy   = "Terraform-Repo2"
  }
}

# 3. Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-public-subnet-a"
    Environment = var.environment
  }
}

# 4. Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "${var.aws_region}b"

  tags = {
    Name        = "${var.environment}-private-subnet-b"
    Environment = var.environment
  }
}

# 5. Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-igw"
  }
}

# 6. Publish Network Identifiers to SSM for downstream repositories (Repo 3 / App Stack)
resource "aws_ssm_parameter" "vpc_id" {
  name      = "/network/vpc_id"
  type      = "String"
  value     = aws_vpc.main.id
  overwrite = true
}

resource "aws_ssm_parameter" "private_subnet_id" {
  name      = "/network/private_subnet_id"
  type      = "String"
  value     = aws_subnet.private.id
  overwrite = true
}
