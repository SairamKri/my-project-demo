resource "aws_vpc_endpoint" "vpce_1" {
  vpc_id             = "vpc-0bdc81838f7f6a73e"  # Replace with your actual VPC ID
  service_name       = "com.amazonaws.us-east-1.s3"  # Replace with actual service name
  vpc_endpoint_type  = "Gateway"
  route_table_ids    = ["rtb-0dbb6c74b1eca77f0"]  # Replace with your actual Route Table ID
  tags = {
    Name = "s3-endpoint"
  }
}

resource "aws_vpc_endpoint" "vpce_2" {
  vpc_id             = "vpc-0bdc81838f7f6a73e"
  service_name       = "com.amazonaws.us-east-1.ssm" # Replace if needed
  vpc_endpoint_type  = "Interface"
  security_group_ids = ["sg-027e5c2cc70542509"] # Replace with actual SG ID
  subnet_ids         = ["subnet-09869cb19a48ce3e4", "subnet-03fd7e78eac8b473f"] # Replace with actual subnet IDs
  tags = {
    Name = "ecr-api-endpoint"
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

