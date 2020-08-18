# User data for ECS cluster
data "template_file" "ecs-cluster" {
  template = "${file("${path.module}/ecs-cluster.tpl")}"

  vars = {
    ecs_cluster = var.cluster_name
  }
}
