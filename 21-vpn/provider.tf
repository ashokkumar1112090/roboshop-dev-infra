terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.28.0"
    }
  }


  backend "s3" {
    bucket = "remote-state-86s-dev-ashok"
    key    = "roboshop-dev-vpn"   #if not given it creates default name or empty
    region = "us-east-1"
    use_lockfile = true
    encrypt = true
  }
}

provider "aws" {
 region = "us-east-1" # Configuration options
}