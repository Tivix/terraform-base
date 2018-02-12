# Create a new load balancer
resource "aws_elb" "this" {
  count = "${var.use_elb == "true" ? 1 : 0}"

  name = "${format("%s-at-%s", var.project_name, var.env)}"

  subnets         = ["${module.vpc.public_subnets}"]
  security_groups = ["${aws_security_group.elb.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  # listener {
  #   instance_port      = 80
  #   instance_protocol  = "http"
  #   lb_port            = 443
  #   lb_protocol        = "https"
  #   ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
  # }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:80"
    interval            = 30
  }
  instances                   = ["${element(module.ec2.id, count.index)}"]
  cross_zone_load_balancing   = false
  idle_timeout                = 400
  connection_draining         = false
  connection_draining_timeout = 400
  tags = {
    Owner       = "${var.owner}"
    Environment = "${var.env}"
  }
}
