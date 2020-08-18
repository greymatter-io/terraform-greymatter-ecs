# User data for ECS cluster
data "template_file" "ecs-cluster" {
  template = "${file("./ecs-cluster.tpl")}"

  vars = {
    ecs_cluster = "gm-cluster"
  }
}
