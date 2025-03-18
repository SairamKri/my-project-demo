# Configure Terraform backend to use S3 and DynamoDB
terraform {
  backend "s3" {
    bucket         = "bitcot-terrform-backend"     # Replace with your S3 bucket name
    key            = "terraform/statefile.tfstate" # Path inside the bucket
    region         = "us-east-1"                   # Change based on your AWS region
    encrypt        = true
    dynamodb_table = "terraform-state-locks" # DynamoDB table for locking
  }
}