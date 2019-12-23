# create security group for load balancer 
# need to only allow traffic on 443, or 80
resource "aws_security_group" "app_alb_sg" {
  name = "alb-sg"
  vpc_id = aws_vpc.app_vpc.id
  }
}


resource "aws_security_group" "app_ecs-task-sg" {
  name = "ecs-task-sg"
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

