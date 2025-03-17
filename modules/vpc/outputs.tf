output "main_vpc"{
    value = aws_vpc.main_vpc.id
}

output "private_subnet_lambda_az_1"{
    value = aws_subnet.private_subnet_lambda_az_1.id
}

output "private_subnet_lambda_az_2"{
    value = aws_subnet.private_subnet_lambda_az_2.id
}

output "private_subnet_ecs_az_1"{
    value = aws_subnet.private_subnet_ecs_az_1.id
}

output "private_subnet_ecs_az_2"{
    value = aws_subnet.private_subnet_ecs_az_2.id
}

output "private_subnet_rds_az_1"{
    value = aws_subnet.private_subnet_rds_az_1.id
}

output "private_subnet_rds_az_2"{
    value = aws_subnet.private_subnet_rds_az_2.id
}