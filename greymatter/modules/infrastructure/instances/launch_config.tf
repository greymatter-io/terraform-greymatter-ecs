resource "aws_launch_configuration" "main" {
  security_groups             = ["${var.security_group_list}"]
  key_name                    = "enter-ecs"
  image_id                    = "ami-035a1bdaf0e4bf265"
  instance_type               = "t2.medium"
  iam_instance_profile        = "${var.iam_instance_profile}"
  user_data                   = "${file("${path.module}/cloud-config.yml")}"
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}
