terraform {
  backend "s3" {
    bucket = "zetancc-terraform-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
