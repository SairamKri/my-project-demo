# CloudFront Origin Access Control (OAC) for secure access to S3
resource "aws_cloudfront_origin_access_control" "bitcot_oac" {
  name                              = "bitcot-oac"
  description                       = "OAC for Bitcot CloudFront"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "bitcot_distribution" {
  origin {
    domain_name              = var.bitcot_bucket_regional_domain_name
    origin_id                = "alivenews_online_s3_origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.bitcot_oac.id
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    target_origin_id         = "alivenews_online_s3_origin"
    allowed_methods          = ["GET", "HEAD"]
    cached_methods           = ["GET", "HEAD"]
    viewer_protocol_policy   = "redirect-to-https"
    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6" # AWS Managed Cache Policy
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf" # AWS Managed Request Policy
  }

  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:908027399760:certificate/f804d829-649b-41c8-a080-60eba2db1505"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "Bitcot CloudFront Distribution"
  }
}