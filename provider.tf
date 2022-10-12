terraform {
  required_version                            = ">= 1.2.6" 

  backend "s3" {
    bucket                                    = "automation-library-terraform-state"
    region                                    = "us-east-1"
    dynamodb_table                            = "automation-library-terraform-state-locks"
    encrypt                                   = "true"
  }

  required_providers {
    aws = {
      source                                  = "hashicorp/aws"
      version                                 = "~> 4.25"
    }
    time = {
      source                                  = "hashicorp/time"
      version                                 = "~>0.7.2"
    }
    tls = {
      source                                  = "hashicorp/tls"
      version                                 = "~>4.0.3"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}