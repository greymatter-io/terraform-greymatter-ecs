resource "aws_lb" "edge" {
  name               = "edge"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.gm-ingress-sg.id]
  subnets            = var.subnets
}

resource "aws_lb_target_group" "edge" {
  name        = "edge"
  port        = var.sidecar_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
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
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn = aws_iam_server_certificate.ingress_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.edge.arn
  }
}

resource "aws_iam_server_certificate" "ingress_cert" {
  name_prefix      = "gm-ecs-ingress-cert"
  certificate_chain = file("./gm/certs/edge/ca.pem")
  certificate_body = file("./gm/certs/edge/cert.pem")
  private_key      = file("./gm/certs/edge/key.pem")

  lifecycle {
    create_before_destroy = true
  }
}

