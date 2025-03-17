resource "aws_db_instance" "my_rds" {
  identifier              = "bitcot-database"
  allocated_storage       = 30
  engine                 = "mysql"
  engine_version         = "8.0.40"
  instance_class         = "db.t4g.micro"
  db_subnet_group_name   = "rds-ec2-db-subnet-group-2"
  vpc_security_group_ids = ["sg-0014e3c352eb142ec", "sg-0aff353c77d0beb01"]
  storage_encrypted      = true
  skip_final_snapshot    = true
  backup_retention_period = 1
  publicly_accessible     = false
  tags = {
    key = "bitcot-database"
  }
}