resource "aws_ecs_cluster" "main" {
  name = "${var.greymatter_ecs_cluster}"

  tags = "${map(
    "Environment", "${var.platform_name}"
  )}"
}
