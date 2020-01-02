# create application load balancer for our ECS service
resource "aws_lb" "app_lb" {
  name = "app-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.app_alb_sg.id]
  subnets = [aws_subnet.app_public_subnet_0.id, aws_subnet.app_public_subnet_1.id]

  depends_on = [aws_security_group.app_alb_sg, aws_subnet.app_public_subnet_0, aws_subnet.app_public_subnet_1]
}

# create target group for our load balancer
resource "aws_lb_target_group" "app_lb_target_group" {
  name = "app-alb-ecs-tg"
  port = 8080
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = aws_vpc.app_vpc.id

  # setup health check
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/health"
    unhealthy_threshold = "2"
  }

  depends_on = [aws_lb.app_lb]
}

# create load balancer listener on port 80
resource "aws_lb_listener" "app_lb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port = "80"
  protocol = "HTTP"

  # configure load listener to foward reqests to target group
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app_lb_target_group.arn
  }
  depends_on = [aws_lb.app_lb, aws_lb_target_group.app_lb_target_group]
}