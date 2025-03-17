resource "aws_acm_certificate" "my_cert" {
  domain_name               = "alivenews.online"
  validation_method         = "DNS"
  key_algorithm             = "RSA_2048"
  subject_alternative_names = ["alivenews.online"]
  tags = {}

  options {
    certificate_transparency_logging_preference = "ENABLED"
  }

  lifecycle {
    create_before_destroy = true
  }
}