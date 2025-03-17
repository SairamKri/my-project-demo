resource "aws_ecs_service" "my_service" {
  name            = "bitcot-service"
  cluster        = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = ["subnet-12345678", "subnet-abcdef12"]
    security_groups = [aws_security_group.ecs_service_sg.id]
    assign_public_ip = true
  }

  desired_count = 2
}
