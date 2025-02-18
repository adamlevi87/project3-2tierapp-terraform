# Get Route 53 Hosted Zone
data "aws_route53_zone" "selected" {
  name         = var.hosted_zone_domain
  private_zone = false
}

# Request an ACM certificate
resource "aws_acm_certificate" "cert" {
  domain_name               = "${var.domain_name}.${var.hosted_zone_domain}"
  subject_alternative_names = [for domain in var.alternative_domain_names : "${domain}.${var.hosted_zone_domain}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Create Route 53 CNAME records for validation
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = data.aws_route53_zone.selected.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

# Validate the ACM Certificate
resource "aws_acm_certificate_validation" "certificates_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}