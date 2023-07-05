data "aws_route53_zone" "poc" {
  name = var.route53_zone_name
}

resource "aws_route53_record" "record" {
  count   = length(var.environments)
  zone_id = data.aws_route53_zone.poc.zone_id
  name    = "${var.repo_name}-${var.region_name}-${var.environments[count.index]}"
  type    = "A"

  alias {
    name                   = aws_lb.app.dns_name
    zone_id                = aws_lb.app.zone_id
    evaluate_target_health = true
  }
}