# create ecs cluster
resource "aws_ecs_cluster" "app_ecs_cluster" {
  name               = "app-ecs-cluster"
  capacity_providers = ["FARGATE"]
}

# create ecs service
resource "aws_ecs_service" "app_ecs_service" {
  name                = "aws-ecs-app"
  cluster             = aws_ecs_cluster.app_ecs_cluster.id
  task_definition     = aws_ecs_task_definition.app_ecs_taskdef.arn
  scheduling_strategy = "REPLICA"
  launch_type         = "FARGATE"
  desired_count       = 4

  # configure service so tasks can only be put in our two private subnets 
  network_configuration {
    security_groups = [aws_security_group.app_ecs_task_sg.id]
    subnets = [aws_subnet.app_private_subnet_0.id, aws_subnet.app_private_subnet_1.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_lb_target_group.arn
    container_name   = "app"
    container_port   = "8080"
  }

  depends_on = [aws_ecs_task_definition.app_ecs_taskdef, aws_lb.app_lb, aws_lb_target_group.app_lb_target_group, aws_ecs_cluster.app_ecs_cluster, aws_security_group.app_ecs_task_sg, aws_subnet.app_private_subnet_0, aws_subnet.app_private_subnet_1]
}

# create our task definition
resource "aws_ecs_task_definition" "app_ecs_taskdef" {
  family = "app"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions = file("./files/task-definition.json")
  cpu = 256
  memory = 512
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  depends_on = [aws_iam_role.ecs_task_execution_role]
}