resource "aws_lb" "edge" {
    name = "edge"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.edge-sg.id]
    subnets = var.subnets
}

resource "aws_lb_target_group" "edge" {
  name     = "edge"
  port     = var.sidecar_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout             = 30
      path                = "/"
      protocol            = "HTTP"
      interval            = 120
      matcher             = "200-304,404"
  }

  depends_on = [aws_lb.edge]
}

resource "aws_lb_listener" "edge" {
  load_balancer_arn = aws_lb.edge.arn
  port              = var.sidecar_port
  protocol          = "HTTP"
  # TODO eventually add ssl
  #ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.edge.arn
  }
}
