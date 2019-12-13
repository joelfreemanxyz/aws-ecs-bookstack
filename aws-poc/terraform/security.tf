resource "aws_security_group" "wikijs_alb_sg" {
  name        = "wikijs_alb_sg"
  description = "Control access to the ELB"
  vpc_id      = "${aws_vpc.wikijs_vpc.id}"
}
# Allow incoming HTTP requests to load balancer
resource "aws_security_group_rule" "wikijs_alb_sg_allow_incoming_http" {
  type              = "ingress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  vpc_id            = "${aws_vpc.wikijs_vpc.id}"
  security_group_id = "${aws_security_group.wikijs_alb_sg.id}"
}
# Allow incoming HTTPS requests to load balancer
resource "aws_security_group_rule" "wikijs_alb_sg_allow_incoming_https" {
  type              = "ingress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  vpc_id            = "${aws_vpc.wikijs_vpc.id}"
  security_group_id = "${aws_security_group.wikijs_alb_sg.id}"
}

resource "aws_security_group" "wikijs_ecs_tasks_sg" {
  name        = "wikijs_ecs_tasks_sg"
  description = "Allow inbound access to tasks from the ALB ONLY."
  vpc_id      = "${aws_vpc.wikijs_vpc.id}"
}
# Allow incoming requests on port 3000 from the load balancer.
resource "aws_security_group_rule" "wikijs_ecs_tasks_sg_allow_incoming_3000" {
  type                    = "ingress"
  from_port               = "3000"
  to_port                 = "3000"
  protocol                = "tcp"
  vpc_id                  = "${aws_vpc.wikijs_vpc.id}"
  security_group_id       = "${aws_security_group.wikijs_ecs_tasks_sg.id}"
  source_security_group_id = "${aws_security_group.wikijs_alb_sg.aw}"
}