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