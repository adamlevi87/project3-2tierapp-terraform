terraform {
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 5.86.0"
    }
    null = {
        source  = "hashicorp/null"
        version = "~> 3.2.3"
    }
  }  
}

# Configuration for the AWS Provider
provider "aws" {
  # Setting up the region
  region = var.region
}