terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  #Store and manage the terraform state on S3 
  
  # backend "s3" {
  #   bucket         = "terraform-remote-state-wordpress-project"
  #   key            = "web/wordpress.tfstate"
  #   region         = "us-east-1a"
  #   dynamodb_table = "terraform-remote-state-dynamodb"
  #   encrypt        = true
  #   role_arn       = var.role_arn.arn
  # }
}

# Configure the AWS Provider
provider "aws" {
  alias = "acm"
  region = "us-east-1"
  profile = "terraform"
}