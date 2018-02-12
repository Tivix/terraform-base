resource "aws_db_instance" "default" {
  allocated_storage       = 10
  storage_type            = "gp2"
  engine                  = "postgres"
  engine_version          = "9.6.5"
  instance_class          = "db.t2.small"
  identifier              = "${format("%s-at-%s", var.project_name, var.env)}"
  name                    = "${var.project_name}"
  username                = "${var.project_name}"
  password                = "${var.project_name}!rules1"
  db_subnet_group_name    = "${module.vpc.database_subnet_group}"
  vpc_security_group_ids  = ["${aws_security_group.rds.id}"]
  backup_retention_period = "7"
}
