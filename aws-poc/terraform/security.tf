resource "aws_security_group" "wikijs_alb_sg" {
  name = "wikijs_alb_sg"
  description = "Controll access to the ELB"
}

resource "aws_security_group" "wikijs_ecs_tasks_sg" {
  name = "wikijs_ecs_tasks_sg"
  description = "Allow inbound access to tasks from the ALB ONLY."
}

resource "aws_security_group" "wikijs_rds_sg" {
  name = "wikijs_rds_sg"
  description = "Allow inbound access from ECS ONLY."
}

