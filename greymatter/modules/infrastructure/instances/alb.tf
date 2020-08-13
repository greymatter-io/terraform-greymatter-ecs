resource "aws_alb_target_group" "greymatter-ip" {
  name        = "greymatter-ecs-alb-target-group"
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = "${var.vpc_id}"
  target_type = "ip"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_target_group" "greymatter" {
  name        = "greymatter-ecs-alb-target-group2"
  port        = "80"
  protocol    = "TCP"
  vpc_id      = "${var.vpc_id}"
  target_type = "instance"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb" "main" {
  name            = "greymatter-ecs-alb"
  subnets         = ["${var.subnet_list}"]
  security_groups = ["${var.security_group_list}"]
}

resource "aws_alb_listener" "main" {
  load_balancer_arn = "${aws_alb.main.id}"
  port              = "80"
  protocol          = "HTTP"
  depends_on        = ["aws_alb_target_group.greymatter"]

  default_action {
    target_group_arn = "${aws_alb_target_group.greymatter.id}"
    type             = "forward"
  }
}

output "main_alb_target_group_arn" {
  value = "${aws_alb_target_group.greymatter.arn}"
}
