# Region
variable "region" {}

# VPC Network
variable "vpc_cidr" {}
variable "private_subnet_lambda_az_1_cidr" {}
variable "private_subnet_lambda_az_2_cidr" {}
variable "private_subnet_ecs_az_1_cidr" {}
variable "private_subnet_ecs_az_2_cidr" {}
variable "private_subnet_rds_az_1_cidr" {}
variable "private_subnet_rds_az_2_cidr" {}
variable "public_subnet_alb_az_1_cidr" {}
variable "public_subnet_alb_az_2_cidr" {}
