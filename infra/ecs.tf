resource "aws_ecs_cluster" "app_ecs_cluster" {
  name               = "app-ecs-cluster"
  capacity_providers = "FARGATE"
}

resource "aws_ecs_service" "app_ecs_service" {
  name                = "aws-ecs-app"
  cluster             = aws_ecs_cluster.app_ecs_cluster.id
  task_definition     = aws_ecs_task_definition.app_ecs_taskdef.arn
  scheduling_strategy = "REPLICA"
  launch_type         = "FARGATE"
  desired_count       = 3
  
  network_configuration {
    security_groups = [aws_security_group.ecs_task_sg.id]
    subnets = [aws_subnet.app_private_subnet_0.id, aws_subnet.app_private_subnet_1.id]
    assign_public_ip = true
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_lb_target_group.arn
    container_name   = "app"
    container_port   = "8080"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [ap-southeast-2a, ap-southeast-2b]"
  }

  depends_on = [aws_ecs_task_definition.app_ecs_taskdef, aws_lb.app_lb, aws_lb_target_group.app_lb_target_group, aws_ecs_cluster.app_ecs_cluster, aws_security_group.ecs_task_sg, aws_subnet.app_private_subnet_0, aws_subnet.app_private_subnet_1]
}

resource "aws_ecs_task_definition" "app_ecs_taskdef" {
  requires_compatibilities = ["FARGATE"]
  family = "app"
  network_mode = "awsvpc"
  cpu = 256
  memory = 512
  container_definitions = file("./files/task-definition.json")
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  
  placement_constraints {
    type = "memberOf"
    expression = "attribute:ecs.availability-zone in [ap-southeast-2a, ap-southeast-2b]"
  }

  depends_on = [aws_iam_role.ecs_task_execution_role]
}