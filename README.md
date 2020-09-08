# terraform-greymatter-ecs

Grey Matter Terraform Code to Deploy Grey Matter using AWS ECS

1. Create 2 parameters in AWS systems manager paremeter store. One named `access_key` with type Secured String and the value the aws access key for your profile. Name the second `secret_access_key` and Secured String value of the corresponding secret access key id. Copy the arns and pass them to terraform as variables `access_key_arn` and `secret_access_key_arn`.

2. Create a secret with docker credentials for greymatter nexus (secret is type `Other`, add key `username` with value docker username, key `password` with value docker password). Pass the arn to terraform as variable `docker_secret_arn`.

3. Run `aws kms describe-key --key-id alias/aws/ssm`, copy the Arn and set it as variable `kms_ssm_arn`.

4. Run `aws kms describe-key --key-id alias/aws/secretsmanager`, copy the Arn and set it as variable `kms_secretsmanager_arn`.

Look through the remaining [variables](greymatter/variables.tf) and make sure to enter the correct values.
