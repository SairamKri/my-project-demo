resource "aws_lb" "my_alb" {
  name               = "Bitcot-Alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-0aff353c77d0beb01"]
  subnets           = ["subnet-009fe17d110260e07", "subnet-0209f3d4b2ae2b8a8"]

  enable_deletion_protection = false

  enable_cross_zone_load_balancing = true
  enable_http2                    = true

  tags = {
    Name = "Bitcot-Alb"
  }
}

resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = "arn:aws:acm:us-east-1:908027399760:certificate/f804d829-649b-41c8-a080-60eba2db1505"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg_simple_requests.arn
  }
}

resource "aws_lb_listener_rule" "complex_requests_rule" {
  listener_arn = aws_lb_listener.my_listener.arn
  priority     = 50000

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg_complex_requests.arn
  }
}

resource "aws_lb_listener_rule" "simple_requests_rule" {
  listener_arn = aws_lb_listener.my_listener.arn
  priority     = 99999

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg_simple_requests.arn
  }
}


resource "aws_lb_target_group" "tg_complex_requests" {
  name     = "Bitcot-Tg"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = "vpc-0bdc81838f7f6a73e"

  health_check {
    enabled             = true
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "Bitcot-Tg"
  }
}

resource "aws_lb_target_group" "tg_simple_requests" {
  name     = "lambda-m249lqp26e2me81vf9pi"
  target_type = "lambda"
}