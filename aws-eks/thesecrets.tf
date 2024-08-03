terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.60.0"
    }
  }

  backend "s3" {
  bucket = "damgitestate"
  key    = "eks-test/terraform.tfstate"
  region = "us-west-2"
  }
}

provider "aws" {
#    region = var.provide_region

    # linux 
    #shared_credentials_files = "~/.aws/credentials"
    #window
#    shared_credentials_files = [var.credentials_path]
    #profile = "default"

}