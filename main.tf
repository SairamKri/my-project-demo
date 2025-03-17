module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  private_subnet_lambda_az_1_cidr = var.private_subnet_lambda_az_1_cidr
  private_subnet_lambda_az_2_cidr = var.private_subnet_lambda_az_2_cidr
  private_subnet_ecs_az_1_cidr = var.private_subnet_ecs_az_1_cidr
  private_subnet_ecs_az_2_cidr = var.private_subnet_ecs_az_2_cidr
  private_subnet_rds_az_1_cidr = var.private_subnet_rds_az_1_cidr
  private_subnet_rds_az_2_cidr = var.private_subnet_rds_az_2_cidr
  public_subnet_alb_az_1_cidr = var.public_subnet_alb_az_1_cidr
  public_subnet_alb_az_2_cidr = var.public_subnet_alb_az_1_cidr
}

