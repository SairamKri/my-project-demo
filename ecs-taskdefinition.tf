resource "aws_ecs_task_definition" "my_task" {
  family                   = "Bitcot-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "my-container"
      image     = "908027399760.dkr.ecr.us-east-1.amazonaws.com/my-repo:latest"
      cpu       = 256
      memory    = 512
      essential = true
      networkMode = "awsvpc"
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}
