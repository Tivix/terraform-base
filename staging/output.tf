# VPC
output "project" {
  description = "Basic info regarding project"
  value       = "${format("%s@%s", var.project_name, var.env)}"
}

# IPs
output "private_ip" {
  value = "${module.ec2.private_ip}"
}

output "public_ip" {
  value = "${aws_eip.this.public_ip}"
}

#RDS
output "db_endpoint" {
  value = "${aws_db_instance.default.endpoint}"
}
