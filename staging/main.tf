# define aws api keys
provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.profile}"
}

# terraform remote state. It needs to be hardcoded due to current implementation. See README.md fo details
terraform {
  backend "s3" {
    encrypt = false
    bucket  = "terraform-shared-states"
    region  = "eu-west-1"
    key     = "terraform-base-staging.tfstate"
    profile = "tivix"
  }
}
