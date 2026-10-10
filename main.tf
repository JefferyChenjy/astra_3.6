## Provider
provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.34"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
  }

  ## backend
  backend "s3" {
    bucket = "sctp-tfstate-ce13"
    key    = "astra_3.6/terraform.tfstate"
    region = "us-east-1"
    # S3 lockfiles disabled: bucket policy denies s3:DeleteObject for students,
    # so Terraform can create the .tflock but never release it.
    use_lockfile = false
  }

  required_version = ">= 1.10.0"
}