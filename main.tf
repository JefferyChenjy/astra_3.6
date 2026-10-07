terraform {
  backend "s3" {
    bucket       = "sctp-tfstate-ce13"
    key          = "astra_3.6/terraform.tfstate"
    region       = "us-east-1"
  }
}

provider "aws" {
   region = "us-east-1"
}

