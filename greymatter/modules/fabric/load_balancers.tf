
# load balancers

#   control-api
#resource "aws_lb" "control-api" {
#    name = "control-api"
#    internal           = false
#    load_balancer_type = "application"
#    security_groups    = [aws_security_group.control-api-sg.id]
#    subnets = var.subnets
#}
#
#resource "aws_lb_target_group" "control-api" {
#  name     = "control-api"
#  port     = 5555
#  protocol = "HTTP"
#  vpc_id   = var.vpc_id
#  depends_on = [aws_lb.control-api]
#
#  health_check {
#      healthy_threshold   = 2
#      unhealthy_threshold = 2
#      timeout             = 30
#      path                = "/"
#      protocol            = "HTTP"
#      interval            = 120
#      matcher             = "200-304,404"
#  }
#}
#
#resource "aws_lb_listener" "control-api" {
#  load_balancer_arn = aws_lb.control-api.arn
#  port              = "5555"
#  protocol          = "HTTP"
#  # TODO eventually add ssl
#  #ssl_policy        = "ELBSecurityPolicy-2016-08"
#
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.control-api.arn
#  }
#}
#
##   control
#
#resource "aws_lb" "control" {
#    name = "control"
#    internal           = false
#    load_balancer_type = "application"
#    security_groups    = [aws_security_group.control-sg.id]
#    subnets = var.subnets
#}
#
#resource "aws_lb_target_group" "control" {
#    name     = "control"
#    port     = 50001
#    protocol = "HTTP"
#    vpc_id   = var.vpc_id
#    depends_on = [aws_lb.control]
#
#    health_check {
#        healthy_threshold   = 2
#        unhealthy_threshold = 2
#        timeout             = 30
#        path                = "/"
#        protocol            = "HTTP"
#        interval            = 120
#        matcher             = "200-304,404"
#    }
#}
#
#resource "aws_lb_listener" "control" {
#  load_balancer_arn = aws_lb.control.arn
#  port              = 50001
#  protocol          = "HTTP"
#  # TODO eventually add ssl
#  #ssl_policy        = "ELBSecurityPolicy-2016-08"
#
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.control.arn
#  }
#}