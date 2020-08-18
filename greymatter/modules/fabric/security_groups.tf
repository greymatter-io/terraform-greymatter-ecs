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

resource "aws_security_group_rule" "control-api-ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = var.gm_sg_id
  source_security_group_id = aws_security_group.control-api-sg.id
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

resource "aws_security_group_rule" "control-ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = var.gm_sg_id
  source_security_group_id = aws_security_group.control-sg.id
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

resource "aws_security_group_rule" "control-api-sidecar-ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = var.gm_sg_id
  source_security_group_id = aws_security_group.control-api-sidecar-sg.id
}