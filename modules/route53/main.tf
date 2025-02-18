# Get Route 53 Hosted Zone
data "aws_route53_zone" "public-zone" {
  name         = var.hosted_zone_domain
  private_zone = false
}


# Create DNS records on Route 53 to point each Domain to The Cloudfront
resource "aws_route53_record" "cloudfront_records" {
  for_each = toset( flatten([var.record_names]) )
  
  zone_id = data.aws_route53_zone.public-zone.zone_id
  name    = each.key
  type    = "A"

  alias {
    name = var.cloudfront_domain_name
    zone_id = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}
