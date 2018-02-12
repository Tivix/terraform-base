module "vpc" {
  source = "github.com/Tivix/terraform-modules/vpc"
  cidr   = "10.10.0.0/16"

  name = "${format("%s-at-%s", var.project_name, var.env)}"
  env  = "${var.env}"

  azs            = ["eu-west-1a", "eu-west-1b"]
  public_subnets = ["10.10.10.0/24"]

  create_database_subnet_group = true
  database_subnets             = ["10.10.20.0/24", "10.10.30.0/24"]

  tags = {
    Owner       = "${var.owner}"
    Environment = "${var.env}"
  }
}
