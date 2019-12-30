resource "aws_security_group" "app_alb_sg" {
  name = "app-alb-sg"
  vpc_id = aws_vpc.app_vpc.id
}

resource "aws_security_group_rule" "app_alb_http_inbound_rule" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  security_group_id = aws_security_group.app_alb_sg.id
}

resource "aws_security_group_rule" "app_alb_http_outbound_rule" {
  type = "egress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  security_group_id = aws_security_group.app_alb_sg.id
}

resource "aws_security_group" "app_ecs_task_sg" {
  name = "app-ecs-task-sg"
  vpc_id = aws_vpc.app_vpc.id

  ingress {
      protocol = "tcp"
      from_port = "8080"
      to_port = "8080"
      security_groups = [aws_security_group.app_alb_sg.id]
  }

  egress {
      protocol = "tcp"
      from_port = "8080"
      to_port = "8080"
      security_groups = [aws_security_group.app_alb_sg.id]
  }
}
