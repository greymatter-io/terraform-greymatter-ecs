# security groups
resource "aws_security_group" "control-api-sg" {
  name   = "control-api-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 5555
    to_port     = 5555
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

resource "aws_security_group" "control-sg" {
  name   = "control-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 50001
    to_port     = 50001
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