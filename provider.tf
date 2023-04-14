
# Configure the AWS Provider
provider "aws" {
  region = var.aws_region

  profile = "zetancc"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}
