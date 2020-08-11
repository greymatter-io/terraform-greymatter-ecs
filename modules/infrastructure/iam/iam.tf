resource "aws_iam_role" "ecs_execution_role" {
  name = "ecsInstanceRole"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
         {
            "Sid": "",
            "Effect": "Allow",
            "Principal":
                  {
                       "Service": "ec2.amazonaws.com",
                       "Service": "ecs-tasks.amazonaws.com"
                  },
            "Action": "sts:AssumeRole"
         }
      ]
  }
EOF
}

resource "aws_iam_instance_profile" "ecs_execution_instance_profile" {
  name = "ecsInstanceRole"
  role = "${aws_iam_role.ecs_execution_role.name}"
}

output "ecs_execution_instance_profile_arn" {
  value = "${aws_iam_instance_profile.ecs_execution_instance_profile.arn}"
}

output "ecs_execution_role_arn" {
  value = "${aws_iam_role.ecs_execution_role.arn}"
}
