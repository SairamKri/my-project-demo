# Lambda Function
resource "aws_lambda_function" "alb_lambda" {
  function_name    = "ProcessRequestsLambda"
  role            = "arn:aws:iam::908027399760:role/service-role/Alb-lambda-1-role-kov2837i"
  handler         = "index.handler"
  runtime         = "nodejs20.x"
  filename        = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")

  vpc_config {
    security_group_ids = ["sg-098fca3a49910aa2c"]
    subnet_ids         = ["subnet-09869cb19a48ce3e4", "subnet-0fffeb0c95600c349"]
  }

  tags = {
    Name = "ALB-Lambda-Function"
  }
}