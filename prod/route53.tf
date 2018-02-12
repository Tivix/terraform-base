data "aws_route53_zone" "selected" {
  count = "${length(var.project_root_domain) > 0 ? 1 : 0}"

  name         = "${var.project_root_domain}."
  private_zone = false
}

resource "aws_route53_record" "direct" {
  count = "${var.use_r53 == "false" ? 1 : 0}"

  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "${var.project_domain}.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.this.public_ip}"]
}

resource "aws_route53_record" "elb" {
  count = "${var.use_r53 == "true" ? 1 : 0}"

  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "${var.project_domain}.${data.aws_route53_zone.selected.name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.this.dns_name}"
    zone_id                = "${aws_elb.this.zone_id}"
    evaluate_target_health = false
  }
}
