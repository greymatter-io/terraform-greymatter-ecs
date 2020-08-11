resource "aws_security_group" "main" {
  name        = "EC2ContainerService-greymatter-ecs-cluster-EcsSecurityGroup-M4LGALUQHS8W"
  description = "ECS Allowed Ports"
  vpc_id      = "${var.vpc_id}"
}

resource "aws_security_group_rule" "main" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["192.168.0.0/16"]
  security_group_id = "${aws_security_group.main.id}"
}

resource "aws_security_group_rule" "main-1" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["50.204.68.162/32"]
  security_group_id = "${aws_security_group.main.id}"
  description       = "SSH from office"
}

resource "aws_security_group_rule" "main-2" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.main.id}"
}

resource "aws_security_group_rule" "main-3" {
  type              = "egress"
  security_group_id = "${aws_security_group.main.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  ipv6_cidr_blocks  = ["::/0"]
}

output "security_group_main_id" {
  value = "${aws_security_group.main.id}"
}
