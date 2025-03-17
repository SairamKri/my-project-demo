resource "aws_security_group" "ecs_service_sg" {
  name        = "ECS-Service-SG"
  description = "Security group for ECS service"
  vpc_id      = "vpc-0bdc81838f7f6a73e"

  ingress {
    from_port   = 80
    to_port     = 80
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
  name        = "ECS-Tasks-SG"
  description = "Security group for ECS tasks"
  vpc_id      = "vpc-0bdc81838f7f6a73e"

  ingress {
    from_port   = 8080
    to_port     = 8080
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
