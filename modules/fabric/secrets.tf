resource "aws_ssm_parameter" "access_key" {
  name        = "access_key"
  type        = "SecureString"
  value       = var.aws_access_key
}

resource "aws_ssm_parameter" "secret_access_key" {
  name        = "secret_access_key"
  type        = "SecureString"
  value       = var.aws_secret_access_key
}