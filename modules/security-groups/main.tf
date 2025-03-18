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
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = ["sg-098fca3a49910aa2c", "sg-0b12f3d4cc0509e8c", "sg-0b221cf6a66d2cd92", "sg-0d0884a6fee7f22aa"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
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
  vpc_id      = "vpc-0bdc81838f7f6a73e" # Replace with your VPC ID

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["sg-0b12f3d4cc0509e8c"] # Replace with actual SG ID
  }

  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = ["sg-0b12f3d4cc0509e8c"] # Replace with actual SG ID
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