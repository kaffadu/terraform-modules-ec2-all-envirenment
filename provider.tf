#0. Configure The Provider
terraform {
  backend "s3" {
    bucket         = "kaffadu-tp2s3statebackend"
    dynamodb_table = "kaffadu-dynamodbtable"
    key            = "global/mystatefile/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
  }
}


# Configuration options
provider "aws" {
  region = var.region
}