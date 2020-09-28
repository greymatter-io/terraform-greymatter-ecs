# ECS Service Role
resource "aws_iam_role" "ecs-service-role" {
  name               = "gm-ecs-service-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs-service-assume-policy.json
}

data "aws_iam_policy_document" "ecs-service-assume-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

# attach managed
resource "aws_iam_role_policy_attachment" "ecs-service-role-managed-attachment" {
  role       = aws_iam_role.ecs-service-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_iam_policy" "ecs-policy-ssm" {
  name        = "ecs-ssm-policy"
  description = "SSM policy for access keys for ecs service role and task role"
  policy      = data.aws_iam_policy_document.ssm_policy.json
}

# attach ssm
resource "aws_iam_role_policy_attachment" "ecs-service-role-ssm-attachment" {
  role       = aws_iam_role.ecs-service-role.name
  policy_arn = aws_iam_policy.ecs-policy-ssm.arn
}

data "aws_iam_policy_document" "ssm_policy" {
  statement {
    actions = [
      "ssm:GetParameters",
      "kms:Decrypt",
    ]
    resources = [
      "${aws_ssm_parameter.aws_access_key.arn}",
      "${aws_ssm_parameter.aws_secret_access_key.arn}",
      "${data.aws_kms_alias.ssm.arn}"
    ]
  }
}

# ECS Task Execution Role
resource "aws_iam_role" "ecs-task-execution-role" {
  name               = "gm-ecs-task-execution-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs-task-execution-role-assume-policy.json
}

data "aws_iam_policy_document" "ecs-task-execution-role-assume-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# attach managed
resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-managed-attachment" {
  role       = aws_iam_role.ecs-task-execution-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# attach ssm policy
resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-ssm-policy-attachment" {
  role       = aws_iam_role.ecs-task-execution-role.name
  policy_arn = aws_iam_policy.ecs-policy-ssm.arn
}

# attach secretsmanager policy
resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-secrets-policy-attachment" {
  role       = aws_iam_role.ecs-task-execution-role.name
  policy_arn = aws_iam_policy.ecs-policy-secretsmanager.arn
}

resource "aws_iam_policy" "ecs-policy-secretsmanager" {
  name        = "ecs-secretsmanager-policy"
  description = "SecretsManager policy for docker credentials for ecs task role"
  policy      = data.aws_iam_policy_document.docker_policy.json
}

data "aws_iam_policy_document" "docker_policy" {
  statement {
    actions = [
      "kms:Decrypt",
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      "${aws_secretsmanager_secret.docker_gm.arn}",
      "${data.aws_kms_alias.secretsmanager.arn}"
    ]
  }
}

# AutoScaling Service Role
resource "aws_iam_service_linked_role" "service-role-for-autoscaling" {
  aws_service_name = "autoscaling.amazonaws.com"
  custom_suffix    = "gm-ecs"
}

# outputs
output "ecs-service-role-arn" {
  value = aws_iam_role.ecs-service-role.arn
}

output "ecs-task-execution-role-arn" {
  value = aws_iam_role.ecs-task-execution-role.arn
}