resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = false
  instance_tenancy     = "default"

  tags = {
    Name = "bitcot-vpc"
  }
}

resource "aws_subnet" "private_subnet_lambda_az_1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.private_subnet_lambda_az_1_cidr # Replace with actual CIDR
  availability_zone       = "us-east-1a"  # Replace with actual AZ
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
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.private_subnet_ecs_az_1_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private-subnet-ECS-AZ-1"
  }
}

resource "aws_subnet" "private_subnet_ecs_az_2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.private_subnet_ecs_az_2_cidr
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private-subnet-ECS-AZ-2"
  }
}

resource "aws_subnet" "private_subnet_rds_az_1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.private_subnet_rds_az_1_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private-subnet-RDS-AZ-1"
  }
}

resource "aws_subnet" "private_subnet_rds_az_2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.private_subnet_rds_az_2_cidr
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private-subnet-RDS-AZ-2"
  }
}

# Create Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "Private-Route-Table"
  }
}

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

