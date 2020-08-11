
# task definitions

resource "aws_ecs_task_definition" "control_api" {
  family                   = "greymatter-control-api"
  container_definitions    = "${file("${path.module}/control-api-task.json")}"
  requires_compatibilities = ["EC2"]
  network_mode             = "host"
  cpu                      = "256"
  memory                   = "800"
  execution_role_arn       = "${var.ecs_execution_role_arn}"
  task_role_arn            = "${var.ecs_execution_role_arn}"
}

resource "aws_ecs_task_definition" "control" {
  family                   = "greymatter-control"
  container_definitions    = "${file("${path.module}/control-task.json")}"
  requires_compatibilities = ["EC2"]
  network_mode             = "host"
  cpu                      = "256"
  memory                   = "400"
  execution_role_arn = "${var.ecs_execution_role_arn}"
  task_role_arn      = "${var.ecs_execution_role_arn}"
}

# service definitions

resource "aws_ecs_service" "control-api" {
    name = "control-api"
    cluster = var.cluster_id
    task_definition = aws_ecs_task_definition.control-api
    iam_role = var.service_role_arn
    desired_count = 1

    load_balancer {
        target_group_arn = aws_lb_target_group.control-api.arn
        container_name = "control-api"
        container_port = 5555
    }
}

resource "aws_ecs_service" "control" {
    name = "control"
    cluster = var.cluster_id
    task_definition = aws_ecs_task_definition.control
    iam_role = var.service_role_arn
    desired_count = 1

    load_balancer {
        target_group_arn = aws_lb_target_group.control.arn
        container_name = "control"
        container_port = 50001
    }
}

resource "aws_ecs_service" "control-api-sidecar" {
    name = "control-api-sidecar"
    cluster = var.cluster_id
    task_definition = aws_ecs_task_definition.control-api-sidecar
    iam_role = var.service_role_arn
    desired_count = 1

    load_balancer {
        target_group_arn = aws_lb_target_group.control-api-sidecar.arn
        container_name = "sidecar"
        container_port = 10808
    }
}

# security groups

resource "aws_security_group" "control-api-sg" {
  name = "control-api-sg"
  ingress {
    from_port   = 5555
    to_port     = 5555
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "control-sg" {
  name = "control-sg"
  ingress {
    from_port   = 50001
    to_port     = 50001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "control-api-sidecar-sg" {
  name = "control-api-sidecar-sg"
  ingress {
    from_port   = 10808
    to_port     = 10808
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


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
        target              = "HTTP:10808/"
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
        target              = "HTTP:50001/"
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