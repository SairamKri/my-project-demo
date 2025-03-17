resource "aws_route53_zone" "my_zone" {
  name    = "alivenews.online"
  comment = "Managed by Terraform"

  tags = {}

  vpc {
    vpc_id = "vpc-0bdc81838f7f6a73e"
  }
}

resource "aws_route53_record" "acm_validation" {
  zone_id = aws_route53_zone.my_zone.id
  name    = "_a2f1ad0bc85ef0236b16353974a12fa5.alivenews.online."
  type    = "CNAME"
  ttl     = 300
  records = ["_54314bc54ed0cfa138174601e943710a.xlfgrmvvlj.acm-validations.aws."]
}

resource "aws_route53_record" "www_cname" {
  zone_id = aws_route53_zone.my_zone.id
  name    = "www.alivenews.online"
  type    = "CNAME"
  ttl     = 300
  records = ["d1234567890abcdef.cloudfront.net"]
}

resource "aws_route53_record" "root_a_record" {
  zone_id = aws_route53_zone.my_zone.id
  name    = "alivenews.online"
  type    = "A"
  alias {
    name                   = "dualstack.alb-1234567890.us-east-1.elb.amazonaws.com"
    zone_id                = "Z35SXDOTRQ7X7K"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "mx_record" {
  zone_id = aws_route53_zone.my_zone.id
  name    = "alivenews.online"
  type    = "MX"
  ttl     = 300
  records = [
    "10 mail1.alivenews.online.",
    "20 mail2.alivenews.online."
  ]
}

resource "aws_route53_record" "txt_record" {
  zone_id = aws_route53_zone.my_zone.id
  name    = "alivenews.online"
  type    = "TXT"
  ttl     = 300
  records = ["v=spf1 include:_spf.google.com ~all"]
}