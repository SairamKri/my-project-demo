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
    security_groups = ["sg-0b12f3d4cc0509e8c", "sg-0b221cf6a66d2cd92", "sg-0d0884a6fee7f22aa"]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = ["sg-0d0884a6fee7f22aa"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["sg-0d0884a6fee7f22aa"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS-SG"
    key  = "RDS-SG"
  }
}