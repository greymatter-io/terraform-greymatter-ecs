
# load balancer
resource "aws_lb" "sidecar-lb" {
    name = "${var.name}-sidecar"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.sidecar-sg.id]
    subnets = var.subnets
}

resource "aws_lb_target_group" "sidecar-tg" {
    name     = "${var.name}-sidecar"
    port     = var.sidecar_port
    protocol = "HTTP"
    vpc_id   = var.vpc_id
    depends_on = [aws_lb.sidecar-lb]

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

resource "aws_lb_listener" "sidecar-listener" {
  load_balancer_arn = aws_lb.sidecar-lb.arn
  port              = var.sidecar_port
  protocol          = "HTTP"
  # TODO eventually add ssl
  #ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sidecar-tg.arn
  }
}
