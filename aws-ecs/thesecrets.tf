
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
# Configure the AWS Provider
provider "aws" {
    #region = var.provide_region

    # linux 
    #shared_credentials_files = "~/.aws/credentials"
    #window
    #shared_credentials_files = [var.credentials_path]
    #profile = "default"

}

terraform {

}