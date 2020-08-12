
# load balancers

#   control-api
resource "aws_lb" "control-api" {
    name = "greymatter-control-api"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.control-api-sg.id]
}

resource "aws_lb_target_group" "control-api" {
  name     = "tf-example-lb-tg"
  port     = 5555
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "control-api" {
  load_balancer_arn = aws_lb.control-api.arn
  port              = "5555"
  protocol          = "HTTP"
  # TODO eventually add ssl
  #ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.control-api.arn
  }
}

#   control-api-sidecar
resource "aws_lb" "control-api-sidecar" {
    name = "greymatter-control-api-sidecar"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.control-api-sidecar-sg.id]
}

resource "aws_lb_target_group" "control-api-sidecar" {
    name     = "control-api-sidecar"
    port     = 10808
    protocol = "HTTP"
    vpc_id   = var.vpc_id

    health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 30
        path                = "/"
        protocol            = "HTTP"
        interval            = 120
        matcher             = "200-304,404"
    }
}

resource "aws_lb_listener" "control-api-sidecar" {
  load_balancer_arn = aws_lb.control-api-sidecar.arn
  port              = "10808"
  protocol          = "HTTP"
  # TODO eventually add ssl
  #ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.control-api-sidecar.arn
  }
}

#   control

resource "aws_lb" "control" {
    name = "greymatter-control"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.control-sg.id]
}

resource "aws_lb_target_group" "control" {
    name     = "control"
    port     = 50001
    protocol = "HTTP"
    vpc_id   = var.vpc_id

    health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 30
        path                = "/"
        protocol            = "HTTP"
        interval            = 120
        matcher             = "200-304,404"
    }
}

resource "aws_lb_listener" "control" {
  load_balancer_arn = aws_lb.control.arn
  port              = 50001
  protocol          = "HTTP"
  # TODO eventually add ssl
  #ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.control.arn
  }
}