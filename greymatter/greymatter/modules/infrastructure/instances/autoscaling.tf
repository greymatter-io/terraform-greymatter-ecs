resource "aws_autoscaling_group" "main" {
  name                 = "EC2ContainerService-greymatter-ecs-cluster-EcsInstanceAsg-1DA526EFJVK0I"
  vpc_zone_identifier  = ["${var.subnet_list}"]
  min_size             = "0"
  max_size             = "3"
  desired_capacity     = "2"
  launch_configuration = "${aws_launch_configuration.main.name}"
}
