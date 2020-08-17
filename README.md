# terraform-greymatter-ecs
Grey Matter Terraform Code to Deploy Grey Matter using AWS ECS

Create 2 parameters in AWS systems manager paremeter store. One named `access_key` with type Secured String and the value the aws access key for your profile. Name the second `secret_access_key` and Secured String value of the corresponding secret access key id.

Pass the arns of these paramters as env var variables `aws_access_key` and `aws_secret_access_key`.

Also make sure you have an existing Secret stored with docker credentials for greymatter nexus.

Pass the arn as `docker_secret_arn`.

Look through the remaining variables in variables.tf and make sure to enter the correct values.
