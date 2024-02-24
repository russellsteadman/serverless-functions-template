# Initialize terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# App prefix variable
variable "app_prefix" {
  description = "The prefix for the app"
  type        = string
  default     = "my-app"
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Environment = terraform.workspace == "prod" ? "prod" : "dev"
      Project     = "My Project"
      Commonality = "specific"
    }
  }
}

# Create environments based on workspace name
locals {
  env    = terraform.workspace == "prod" ? "prod" : "dev"
  region = "us-east-1"
}
