# create docker credentials secret for greymatter nexus
resource "aws_secretsmanager_secret" "docker_gm" {
  name_prefix = "gm-docker-secret"
}

resource "aws_secretsmanager_secret_version" "docker_gm" {
  secret_id     = aws_secretsmanager_secret.docker_gm.id
  secret_string = jsonencode(var.docker_gm_credentials)
}

# create ssm paramters with access key and secret access key
# for Grey Matter control & infrastructure role policies
resource "aws_ssm_parameter" "aws_access_key" {
  name        = "greymatter-ecs-aws-access-key"
  description = "AWS Access Key ID for Grey Matter Control"
  type        = "SecureString"
  value       = var.aws_access_key_id
}

resource "aws_ssm_parameter" "aws_secret_access_key" {
  name        = "greymatter-ecs-aws-secret-access-key"
  description = "AWS Secret Access Key ID for Grey Matter Control"
  type        = "SecureString"
  value       = var.aws_secret_access_key
}

data "aws_kms_alias" "ssm" {
  name = "alias/aws/ssm"
}

data "aws_kms_alias" "secretsmanager" {
  name = "alias/aws/secretsmanager"
}