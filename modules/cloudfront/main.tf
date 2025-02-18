# Get the certificate from AWS ACM
data "aws_acm_certificate" "issued" {
  domain   = "${var.domain_name}.${var.hosted_zone_domain}"
  statuses = ["ISSUED"]
}

#creating Cloudfront distribution :
resource "aws_cloudfront_distribution" "my_distribution" {
  enabled = true
  aliases = concat(
    [ "${var.domain_name}.${var.hosted_zone_domain}" ],
    [for domain in var.alternative_domain_names : "${domain}.${var.hosted_zone_domain}"]
  )
  
  origin {
    domain_name = var.alb_domain_name
    origin_id   = var.alb_domain_name
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = var.alb_domain_name
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      headers      = []
      query_string = true
      cookies {
        forward = "all"
      }
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations = []
    }
  }
  # restrictions {
  #   geo_restriction {
  #     restriction_type = "none"
  #     # restriction_type = "whitelist"
  #     # locations        = ["IN", "US", "CA"]
  #   }
  # }
  tags = {
    Name = "${var.project_name}-cloudfront"
    Project = var.project_name
  }
  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.issued.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }
}