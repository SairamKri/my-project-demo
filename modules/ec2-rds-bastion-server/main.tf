resource "aws_instance" "rds_jump_server" {
  ami                    = "ami-04b4f1a9cf54c11d0"
  instance_type          = "t2.micro"
  key_name               = "bitcot-rds-jump-server"
  subnet_id              = "subnet-0209f3d4b2ae2b8a8"
  vpc_security_group_ids = ["sg-03a343d7a2a388c6f", "sg-0b221cf6a66d2cd92"]
  tags = {
    Name = "Bitcot-database-jump-server"
  }
}