# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/ProcessRequestsLambda"
  retention_in_days = 30

  tags = {
    Name = "Lambda-Log-Group"
  }
}

# CloudWatch Log Stream (for Lambda logs)
resource "aws_cloudwatch_log_stream" "lambda_log_stream" {
  name           = "ecs/Bitcot-container/" # Replace with your log stream name
  log_group_name = aws_cloudwatch_log_group.lambda_log_group.name
}

