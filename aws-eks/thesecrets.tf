terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.60.0"
    }
  }
}

provider "aws" {
    region = var.provide_region

    # linux 
    #shared_credentials_files = "~/.aws/credentials"
    #window
    shared_credentials_files = [var.credentials_path]
    #profile = "default"

}