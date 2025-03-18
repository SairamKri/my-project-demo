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

# Public Subnets Details

resource "aws_subnet" "public_subnet_alb_az_1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_alb_az_1_cidr
  availability_zone       = "us-east-1a"
  tags = {
    Name = "Public-subnet-ALB-AZ-1"
  }
}

resource "aws_subnet" "public_subnet_alb_az_2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_alb_az_2_cidr
  availability_zone       = "us-east-1b"

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
