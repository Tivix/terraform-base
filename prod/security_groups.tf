# module "security_group" {
#   source = "github.com/Tivix/terraform-modules/sg"

#   name        = "sg_http_ssh"
#   description = "sg with open ports for http, ssh, docker-cloud"
#   vpc_id      = "${module.vpc.vpc_id}"

#   ingress_cidr_blocks = ["0.0.0.0/0"]
#   ingress_rules       = ["http-80-tcp", "ssh-tcp", "docker-cloud-api", "docker-cloud"]
#   egress_rules        = ["all-all"]
# }
resource "aws_security_group" "elb" {
  count = "${var.use_elb == "true" ? 1 : 0}"

  name        = "sg_elb"
  description = "Allow http and https from all"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds" {
  count = "${var.use_rds == "true" ? 1 : 0}"

  name        = "sg_rds"
  description = "Allow for access from ec2 only"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = ["${aws_security_group.main.id}"]
  }
}

resource "aws_security_group" "ssh" {
  name        = "sg_ssh"
  description = "Allow for ssh from all"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "zabbix" {
  name        = "sg_zabbix"
  description = "Allow for zabbix from server"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 10050
    to_port     = 10050
    protocol    = "tcp"
    cidr_blocks = ["54.67.124.249/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "main" {
  name        = "sg_default"
  description = "Custom, project specific set of rules"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.elb.id}"]
  }

  ingress {
    from_port   = 2375
    to_port     = 2375
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6783
    to_port     = 6783
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6783
    to_port     = 6783
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
