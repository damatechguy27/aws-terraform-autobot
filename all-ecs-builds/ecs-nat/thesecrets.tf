# Provider configuration
provider "aws" {
  region = var.aws_region # "us-west-2" "us-east-1"
  profile = var.aws_profile
}
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.60.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.6.1"
    }
  }
  
  backend "s3" {
  bucket = "damgitestate"
  key    = "ecs-test/terraform.tfstate"
  region = "us-west-2"
  }
  
}
