# edge load balancer security group
resource "aws_security_group" "gm-ingress-sg" {
  name   = "gm-ingress-sg"
  vpc_id = var.vpc_id
  ingress {
   description = "mesh ingress"
    from_port   = 443
    to_port     = 443
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