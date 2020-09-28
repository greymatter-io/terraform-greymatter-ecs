# create ssm parameters for access key and secret access key
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

output "ssm_access_key_arn" {
  value = aws_ssm_parameter.aws_access_key.arn
}

output "ssm_secret_access_key_arn" {
  value = aws_ssm_parameter.aws_secret_access_key.arn
}