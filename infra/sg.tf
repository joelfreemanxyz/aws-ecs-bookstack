# create sg for our load balancer
resource "aws_security_group" "app_alb_sg" {
  name = "alb-sg"
  vpc_id = aws_vpc.app_vpc.id

  # allow incoming HTTP traffic
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow incoming ICMP traffic
  ingress {
    protocol    = "icmp"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow all outgoing traffic
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [aws_vpc.app_vpc]
}

# create sg for our ecs tasks
resource "aws_security_group" "app_ecs_task_sg" {
  name = "app-ecs-task-sg"
  vpc_id = aws_vpc.app_vpc.id

  # allow incoming traffic on port 8080 only from our load balancer security group
  ingress {
    protocol        = "tcp"
    from_port       = "8080"
    to_port         = "8080"
    security_groups = [aws_security_group.app_alb_sg.id]
  }

  # allow all outgoing traffic 
  egress {
    protocol    = "-1"
    from_port   = "0"
    to_port     = "0"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  depends_on = [aws_security_group.app_alb_sg, aws_vpc.app_vpc]
}
