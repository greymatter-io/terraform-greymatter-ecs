# security groups

resource "aws_security_group" "sidecar-sg" {
  name   = "${var.name}-sidecar-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port   = var.sidecar_port
    to_port     = var.sidecar_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "sidecar-ingress" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = var.gm_sg_id
  source_security_group_id = aws_security_group.sidecar-sg.id
}
