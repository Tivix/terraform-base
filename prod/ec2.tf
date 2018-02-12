data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

module "ec2" {
  source = "github.com/Tivix/terraform-modules/ec2"

  env = "${var.env}"

  count                       = "${var.instances_count}"
  name                        = "${format("%s@%s", var.project_name, var.env)}"
  key_name                    = "${var.masterkey}"
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${element(module.vpc.public_subnets, 0)}"
  vpc_security_group_ids      = ["${aws_security_group.ssh.id}", "${aws_security_group.zabbix.id}", "${aws_security_group.main.id}"]
  associate_public_ip_address = true
}

resource "aws_eip" "this" {
  instance = "${element(module.ec2.id, count.index)}"
  vpc      = true
}

# uncomment if using ansible as server provisioner


# resource "null_resource" "ansible_inventory" {
#   triggers {
#     eip_id = "${aws_eip.this.id}"
#   }


#   provisioner "local-exec" {
#     command = "echo \"[webservers]\n${aws_eip.this.public_ip}\" > ../../ansible/prod"
#   }
# }

