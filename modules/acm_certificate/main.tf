# SSL/TLS certificate in North Virginia for Accelerator DLT test Cloudfront CNAME
data "aws_route53_zone" "poc" {
  name = var.route53_zone_name
}

resource "aws_acm_certificate" "acm" {
  domain_name               = var.route53_zone_name
  validation_method         = "DNS"
  subject_alternative_names = [
    "*.${var.route53_zone_name}"
  ]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "example" {
  for_each = {
    for dvo in aws_acm_certificate.acm.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
   # Skips the domain if it doesn't contain a wildcard
    if length(regexall("\\*\\..+", dvo.domain_name)) > 0
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.poc.zone_id
}

resource "aws_acm_certificate_validation" "example" {
  certificate_arn         = aws_acm_certificate.acm.arn
  validation_record_fqdns = [for record in aws_route53_record.example : record.fqdn]
}