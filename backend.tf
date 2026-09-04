terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket       = "rush-658469472575"          # Your central S3 bucket created in Repo 1
    key          = "network/terraform.tfstate"  # Isolated state path for Repo 2
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true                         # Native S3 State Locking (No DynamoDB required)
  }
}

provider "aws" {
  region = var.aws_region
}
