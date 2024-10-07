# Provider
provider "aws" {
  region = "ca-central-1"
}

# Task 1: Create Hosted Zone
resource "aws_route53_zone" "example_zone" {
  name    = "example.com"
  comment = "Public hosted zone for example project"
}

# Task 2: Configure Domain Name (e.g., api.example.com)
resource "aws_route53_record" "api_gateway" {
  zone_id = aws_route53_zone.example_zone.zone_id
  name    = "api.example.com"
  type    = "A"
  alias {
    name                   = aws_api_gateway_domain_name.api_gateway_domain.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.api_gateway_domain.cloudfront_zone_id
    evaluate_target_health = true
  }
}

# Task 3: Set up Alias Records (for API Gateway and CloudFront)
resource "aws_api_gateway_domain_name" "api_gateway_domain" {
  domain_name     = "api.example.com"
  certificate_arn = aws_acm_certificate_validation.api_gateway_cert.certificate_arn
}

resource "aws_acm_certificate" "api_gateway_cert" {
  domain_name       = "api.example.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Updated: Use for_each to create Route 53 DNS validation records for each domain validation option
resource "aws_route53_record" "api_gateway_validation" {
  for_each = { for dvo in aws_acm_certificate.api_gateway_cert.domain_validation_options : dvo.domain_name => dvo }

  zone_id = aws_route53_zone.example_zone.zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  ttl     = 60
  records = [each.value.resource_record_value]
}

resource "aws_acm_certificate_validation" "api_gateway_cert" {
  certificate_arn         = aws_acm_certificate.api_gateway_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.api_gateway_validation : record.fqdn]
}

# Task 4: Establish Failover Routing Policies
resource "aws_route53_zone" "secondary_zone" {
  name    = "backup-api-endpoint.example.com"
  comment = "Secondary hosted zone for backup API endpoint"
}

resource "aws_route53_record" "api_gateway_failover_primary" {
  zone_id        = aws_route53_zone.example_zone.zone_id
  name           = "api.example.com"
  type           = "A"
  set_identifier = "primary"
  alias {
    name                   = aws_api_gateway_domain_name.api_gateway_domain.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.api_gateway_domain.cloudfront_zone_id
    evaluate_target_health = true
  }
  failover_routing_policy {
    type = "PRIMARY"
  }
}

resource "aws_route53_record" "api_gateway_failover_secondary" {
  zone_id        = aws_route53_zone.secondary_zone.zone_id
  name           = "backup-api-endpoint.example.com"
  type           = "A"
  set_identifier = "secondary"
  alias {
    name                   = aws_api_gateway_domain_name.secondary_api_gateway_domain.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.secondary_api_gateway_domain.cloudfront_zone_id
    evaluate_target_health = true
  }
  failover_routing_policy {
    type = "SECONDARY"
  }
}

resource "aws_api_gateway_domain_name" "secondary_api_gateway_domain" {
  domain_name     = "backup-api-endpoint.example.com"
  certificate_arn = aws_acm_certificate_validation.secondary_api_gateway_cert.certificate_arn
}

resource "aws_acm_certificate" "secondary_api_gateway_cert" {
  domain_name       = "backup-api-endpoint.example.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Updated: Use for_each to create Route 53 DNS validation records for each domain validation option
resource "aws_route53_record" "secondary_api_gateway_validation" {
  for_each = { for dvo in aws_acm_certificate.secondary_api_gateway_cert.domain_validation_options : dvo.domain_name => dvo }

  zone_id = aws_route53_zone.secondary_zone.zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  ttl     = 60
  records = [each.value.resource_record_value]
}

resource "aws_acm_certificate_validation" "secondary_api_gateway_cert" {
  certificate_arn         = aws_acm_certificate.secondary_api_gateway_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.secondary_api_gateway_validation : record.fqdn]
}

# Task 5: Integrate with CloudFront (If applicable)
resource "aws_cloudfront_distribution" "ui_distribution" {
  origin {
    domain_name = aws_s3_bucket.ui_bucket.bucket_regional_domain_name
    origin_id   = "S3-ui-bucket"
  }

  enabled              = true
  default_root_object  = "index.html"

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-ui-bucket"
    viewer_protocol_policy = "redirect-to-https"
  }
}

# S3 bucket for CloudFront integration
resource "aws_s3_bucket" "ui_bucket" {
  bucket = "example-ui-bucket"
}

resource "aws_s3_bucket_acl" "ui_bucket_acl" {
  bucket = aws_s3_bucket.ui_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_versioning" "ui_bucket_versioning" {
  bucket = aws_s3_bucket.ui_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Task 6: Enable DNSSEC
resource "aws_route53_hosted_zone_dnssec" "dnssec" {
  hosted_zone_id = aws_route53_zone.example_zone.zone_id
}

resource "aws_route53_key_signing_key" "ksk" {
  hosted_zone_id                = aws_route53_zone.example_zone.zone_id
  name                          = "example-key-signing-key"
  status                        = "ACTIVE"
  key_management_service_arn    = "arn:aws:iam::017820679929:user/payment-gateway-dev"
}

