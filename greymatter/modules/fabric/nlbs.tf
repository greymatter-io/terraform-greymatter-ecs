# network load balancers

# control-api
resource "aws_lb" "control-api" {
  name               = "control-api"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.subnets
}

resource "aws_lb_target_group" "control-api" {
  name     = "control-api"
  port     = 80
  protocol = "TCP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "control-api" {
  load_balancer_arn = aws_lb.control-api.arn
  port = 80
  protocol = "TCP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.control-api.arn
  }
}

# control
resource "aws_lb" "control" {
  name               = "control"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.subnets
}

resource "aws_lb_target_group" "control" {
  name     = "control"
  port     = 80
  protocol = "TCP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "control" {
  load_balancer_arn = aws_lb.control.arn
  port = 80
  protocol = "TCP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.control.arn
  }
}