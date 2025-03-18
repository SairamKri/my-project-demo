resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "bitcot-vpc"
  }
}

resource "aws_subnet" "private_subnet_lambda_az_1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.private_subnet_lambda_az_1_cidr # Replace with actual CIDR
  availability_zone       = "us-east-1a"                        # Replace with actual AZ
  map_public_ip_on_launch = false

  tags = {
    Name = "Private-subnet-Lambda-AZ-1"
  }
}

resource "aws_subnet" "private_subnet_lambda_az_2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.private_subnet_lambda_az_2_cidr
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private-subnet-Lambda-AZ-2"
  }
}


resource "aws_subnet" "private_subnet_ecs_az_1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private-subnet-ECS-AZ-1"
  }
}


resource "aws_subnet" "private_subnet_ecs_az_2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private-subnet-ECS-AZ-2"
  }
}

resource "aws_subnet" "private_subnet_rds_az_1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.5.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private-subnet-RDS-AZ-1"
  }
}

resource "aws_subnet" "private_subnet_rds_az_2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.6.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private-subnet-RDS-AZ-2"
  }
}

# Public Subnets Details

resource "aws_subnet" "public_subnet_alb_az_1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.7.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Public-subnet-ALB-AZ-1"
  }
}

resource "aws_subnet" "public_subnet_alb_az_2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.8.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Public-subnet-ALB-AZ-2"
  }
}

# Create Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "Private-Route-Table"
  }
}

# Create Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public-Route-Table"
  }
}

//Creating the Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "Bitcot-igw"
  }
}

# Creating the private route table association with private subnet
resource "aws_route_table_association" "private_rt_asso_lambda_az_1" {
  subnet_id      = aws_subnet.private_subnet_lambda_az_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_asso_lambda_az_2" {
  subnet_id      = aws_subnet.private_subnet_lambda_az_2.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_asso_ecs_az_1" {
  subnet_id      = aws_subnet.private_subnet_ecs_az_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_asso_ecs_az_2" {
  subnet_id      = aws_subnet.private_subnet_ecs_az_2.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_asso_rds_az_1" {
  subnet_id      = aws_subnet.private_subnet_rds_az_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_asso_rds_az_2" {
  subnet_id      = aws_subnet.private_subnet_rds_az_2.id
  route_table_id = aws_route_table.private_rt.id
}

# Creating the Route Table Associaions with route table and public subnets
resource "aws_route_table_association" "public_rt_asso_alb_az_1" {
  subnet_id      = aws_subnet.public_subnet_alb_az_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_asso_alb_az_2" {
  subnet_id      = aws_subnet.public_subnet_alb_az_2.id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_vpc_endpoint" "vpce_1" {
  vpc_id            = "vpc-0bdc81838f7f6a73e"      # Replace with your actual VPC ID
  service_name      = "com.amazonaws.us-east-1.s3" # Replace with actual service name
  vpc_endpoint_type = "Gateway"
  route_table_ids   = ["rtb-0dbb6c74b1eca77f0"] # Replace with your actual Route Table ID
  tags = {
    Name = "s3-endpoint"
  }
}

resource "aws_vpc_endpoint" "vpce_2" {
  vpc_id             = aws_vpc.main_vpc.id
  service_name       = "com.amazonaws.us-east-1.ecr.api" # Ensure this matches the state
  vpc_endpoint_type  = "Interface"
  security_group_ids = ["sg-027e5c2cc70542509"]
  subnet_ids         = ["subnet-03fd7e78eac8b473f", "subnet-09869cb19a48ce3e4"]

  tags = {
    Name = "VPC-Endpoint-SSM"
  }
}

resource "aws_vpc_endpoint" "vpce_3" {
  vpc_id             = "vpc-0bdc81838f7f6a73e"
  service_name       = "com.amazonaws.us-east-1.ec2" # Example, replace if needed
  vpc_endpoint_type  = "Interface"
  security_group_ids = ["sg-027e5c2cc70542509"]
  subnet_ids         = ["subnet-09869cb19a48ce3e4", "subnet-03fd7e78eac8b473f"]
  tags = {
    Name = "ecr-dkr-endpoint"
  }
}

resource "aws_vpc_endpoint" "vpce_4" {
  vpc_id             = "vpc-0bdc81838f7f6a73e"
  service_name       = "com.amazonaws.us-east-1.logs" # Example, replace if needed
  vpc_endpoint_type  = "Interface"
  security_group_ids = ["sg-027e5c2cc70542509"]
  subnet_ids         = ["subnet-09869cb19a48ce3e4", "subnet-03fd7e78eac8b473f"]
  tags = {
    Name = "cloudwatch-logs-endpoint"
  }
}

resource "aws_security_group" "ec2_jump_sg" {
  name        = "EC2-Jump-Server-SG"
  description = "ec2-sg"
  vpc_id      = "vpc-0bdc81838f7f6a73e"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["sg-083a711f9849ef2e4"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2-Jump-Server-SG"
  }
}

resource "aws_security_group" "my_rds_sg" {
  name        = "RDS-SG"
  description = "receives the traffic from ecs tasks"
  vpc_id      = "vpc-0bdc81838f7f6a73e"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["sg-098fca3a49910aa2c", "sg-0b12f3d4cc0509e8c", "sg-0b221cf6a66d2cd92", "sg-0d0884a6fee7f22aa"]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = ["sg-0d0884a6fee7f22aa"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS-SG"
  }
}

resource "aws_security_group" "ecs_service_sg" {
  name        = "ecs-service-sg"
  description = "Allow inbound access for ECS Service"
  vpc_id      = "vpc-0bdc81838f7f6a73e"

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_task_sg" {
  name        = "ecs-task-sg"
  description = "Allow ECS Tasks to communicate with necessary services"
  vpc_id      = "vpc-0bdc81838f7f6a73e"

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_service_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for Application Load Balancer (ALB)
resource "aws_security_group" "alb_sg" {
  name        = "ALB-SG"
  description = "Alb receives the traffic from the outside and transfers it to ECS services"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = ["sg-098fca3a49910aa2c"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB-SG"
  }
}

# Security Group for AWS Lambda
resource "aws_security_group" "lambda_sg" {
  name        = "Alb-lambda-trigger-1"
  description = "Allows the traffic from ALB"
  vpc_id      = "vpc-0bdc81838f7f6a73e" # Replace with your VPC ID

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = ["sg-0aff353c77d0beb01"] # ALB Security Group
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Alb-lambda-trigger-1"
  }
}

# Security Group for VPC Endpoints
resource "aws_security_group" "vpc_endpoints_sg" {
  name        = "VPC-Endpoints-SG"
  description = "Security Group for VPC Endpoints"
  vpc_id      = "vpc-0bdc81838f7f6a73e" # Replace with your VPC ID

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Replace with your VPC CIDR
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "VPC-Endpoints-SG"
  }
}

# S3 Bucket for storing static assets
resource "aws_s3_bucket" "bitcot_bucket" {
  bucket = "alivenews.online"

  tags = {
    Name = "Bitcot S3 Bucket"
  }
}

# S3 Bucket Public Access Block (Disable public access, we use OAC)
resource "aws_s3_bucket_public_access_block" "bitcot_bucket_access" {
  bucket = aws_s3_bucket.bitcot_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 Bucket Policy to allow CloudFront access
resource "aws_s3_bucket_policy" "bitcot_bucket_policy" {
  bucket = aws_s3_bucket.bitcot_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "PolicyForCloudFrontPrivateContent"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::alivenews.online/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudfront::908027399760:distribution/EXYGVZPNOZAFL"
          }
        }
      }
    ]
  })
}

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

resource "aws_db_instance" "my_rds" {
  identifier              = "bitcot-database"
  allocated_storage       = 30
  engine                  = "mysql"
  engine_version          = "8.0.40"
  instance_class          = "db.t4g.micro"
  db_subnet_group_name    = "rds-ec2-db-subnet-group-2"
  vpc_security_group_ids  = ["sg-0014e3c352eb142ec", "sg-0aff353c77d0beb01"]
  storage_encrypted       = true
  skip_final_snapshot     = true
  backup_retention_period = 1
  publicly_accessible     = false
  tags = {
    key = "bitcot-database"
  }
}

# Lambda Function
resource "aws_lambda_function" "alb_lambda" {
  function_name    = "ProcessRequestsLambda"
  role             = "arn:aws:iam::908027399760:role/service-role/Alb-lambda-1-role-kov2837i"
  handler          = "index.handler"
  runtime          = "nodejs20.x"
  filename         = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")

  vpc_config {
    security_group_ids = ["sg-098fca3a49910aa2c"]
    subnet_ids         = ["subnet-09869cb19a48ce3e4", "subnet-0fffeb0c95600c349"]
  }

  tags = {
    Name = "ALB-Lambda-Function"
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role" "ecs_task_role" {
  name = "ecsTaskRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Role for Lambda to connect to RDS
resource "aws_iam_role" "lambda_rds_role" {
  name               = "Alb-lambda-1-role-kov2837i"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_policy.json
}

data "aws_iam_policy_document" "lambda_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "lambda_rds_policy" {
  role       = aws_iam_role.lambda_rds_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

# IAM Role for RDS Monitoring
resource "aws_iam_role" "rds_monitoring_role" {
  name               = "rds-monitoring-role"
  assume_role_policy = data.aws_iam_policy_document.rds_assume_policy.json
}

data "aws_iam_policy_document" "rds_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "rds_monitoring_attachment" {
  role       = aws_iam_role.rds_monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_ecs_cluster" "my_cluster" {
  name = "my-cluster"
}

resource "aws_ecs_task_definition" "my_task" {
  family                   = "my-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  cpu                      = "512"
  memory                   = "1024"

  container_definitions = jsonencode([
    {
      name        = "my-container"
      image       = "908027399760.dkr.ecr.us-east-1.amazonaws.com/my-repo:latest"
      cpu         = 256
      memory      = 512
      essential   = true
      networkMode = "awsvpc"

      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/my-task"
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "my_service" {
  name            = "my-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = ["subnet-12345678", "subnet-87654321"]
    security_groups  = [aws_security_group.ecs_service_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:908027399760:targetgroup/Bitcot-Tg/5ca65ecdf1507bec"
    container_name   = "my-container"
    container_port   = 5000
  }
}

resource "aws_ecr_repository" "my_ecr" {
  name                 = "bitcotrepo"
  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    Name = "bitcotrepo"
  }
}


resource "aws_instance" "rds_jump_server" {
  ami                    = "ami-04b4f1a9cf54c11d0"
  instance_type          = "t2.micro"
  key_name               = "bitcot-rds-jump-server"
  subnet_id              = "subnet-0209f3d4b2ae2b8a8"
  vpc_security_group_ids = ["sg-03a343d7a2a388c6f", "sg-0b221cf6a66d2cd92"]
  tags = {
    Name = "Bitcot-database-jump-server"
  }
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/ProcessRequestsLambda"
  retention_in_days = 30

  tags = {
    Name = "Lambda-Log-Group"
  }
}

# CloudWatch Log Stream (for Lambda logs)
resource "aws_cloudwatch_log_stream" "lambda_log_stream" {
  name           = "ecs/Bitcot-container/" # Replace with your log stream name
  log_group_name = aws_cloudwatch_log_group.lambda_log_group.name
}

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
    domain_name              = "alivenews.online"
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

resource "aws_lb" "my_alb" {
  name               = "Bitcot-Alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-0aff353c77d0beb01"]
  subnets            = ["subnet-009fe17d110260e07", "subnet-0209f3d4b2ae2b8a8"]

  enable_deletion_protection = false

  enable_cross_zone_load_balancing = true
  enable_http2                     = true

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
    type             = "forward"
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
    type             = "forward"
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
    type             = "forward"
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
  name        = "lambda-m249lqp26e2me81vf9pi"
  target_type = "lambda"
}

resource "aws_acm_certificate" "my_cert" {
  domain_name               = "alivenews.online"
  validation_method         = "DNS"
  key_algorithm             = "RSA_2048"
  subject_alternative_names = ["alivenews.online"]
  tags                      = {}

  options {
    certificate_transparency_logging_preference = "ENABLED"
  }

  lifecycle {
    create_before_destroy = true
  }
}

