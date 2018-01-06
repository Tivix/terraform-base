# define aws api keys
provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.profile}"
}

# terraform remote state. It needs to be hardcoded due to current implementation
terraform {
  backend "s3" {
    encrypt = false
    bucket  = "terraform-shared-states"
    region  = "eu-west-1"
    key     = "terraform-base/staging.tfstate"
    profile = "tivix"
  }
}

module "vpc" {
  source = "github.com/Tivix/terraform-modules/vpc"
  cidr   = "10.10.0.0/16"

  name = "${format("%s@%s", var.project_name, var.env)}"
  env  = "${var.env}"

  azs            = ["eu-west-1a"]
  public_subnets = ["10.10.10.0/24"]

  create_database_subnet_group = false

  tags = {
    Owner       = "${var.owner}"
    Environment = "${var.env}"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

module "security_group" {
  source = "github.com/Tivix/terraform-modules/sg"

  name        = "sg_http_ssh"
  description = "sg with open http and ssh"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "ssh-tcp"]
  egress_rules        = ["all-all"]
}

module "ec2" {
  source = "github.com/Tivix/terraform-modules/ec2"

  env = "${var.env}"

  name                        = "${format("%s@%s", var.project_name, var.env)}"
  key_name                    = "${var.masterkey}"
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${element(module.vpc.public_subnets, 0)}"
  vpc_security_group_ids      = "${module.security_group.this_security_group_id}"
  associate_public_ip_address = true
}

resource "aws_eip" "this" {
  instance = "${element(module.ec2.id, count.index)}"
  vpc      = true
}

# resource "null_resource" "ansible_inventory" {
#   triggers {
#     eip_id = "${aws_eip.this.id}"
#   }


#   provisioner "local-exec" {
#     command = "echo \"[webserver]\n${aws_eip.this.public_ip}\" > ../ansible/staging"
#   }
# }

