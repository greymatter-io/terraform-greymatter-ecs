# terraform-greymatter-ecs

Grey Matter Terraform Code to Deploy Grey Matter using AWS ECS

## Pre-install

1. Create 2 parameters in AWS systems manager paremeter store. One named `access_key` with type Secured String and the value the aws access key for your profile. Name the second `secret_access_key` and Secured String value of the corresponding secret access key id. Copy the arns and pass them to terraform as variables `access_key_arn` and `secret_access_key_arn`.

2. Create a secret with docker credentials for greymatter nexus (secret is type `Other`, add key `username` with value docker username, key `password` with value docker password). Pass the arn to terraform as variable `docker_secret_arn`.

3. Run `aws kms describe-key --key-id alias/aws/ssm`, copy the Arn and set it as variable `kms_ssm_arn`.

4. Run `aws kms describe-key --key-id alias/aws/secretsmanager`, copy the Arn and set it as variable `kms_secretsmanager_arn`.

Look through the remaining [variables](greymatter/variables.tf) and make sure to enter the correct values.

## Install

Create a var file that looks like the following:

```bash
#docker_secret_arn      = "arn:aws:secretsmanager:us-east-2:090224759624:secret:docker-gm-nexus-rwdgiA"
access_key_arn         = "{output of step 1 in pre-install}"
secret_access_key_arn  = "{output of step 1 in pre-install}"
aws_region             = "{region}"
key_pair_name          = "{name of existing keypair for ssh}"
kms_ssm_arn            = "{output of step 3 in pre-install}"
kms_secretsmanager_arn = "{output of step 4 in pre-install}"
optimized_ami          = "{ecs optimized ami - TODO document here how to find this}"
docker_gm_credentials  = {"username": "{greymatter-nexus-email}", "password": "{greymatter-nexus-password}"}
```

To install the mesh:

```bash
terraform apply -var-file=varfile.tfvars
```

When the mesh comes up, the edge dns name should be output. Give the target group ~10 min to register the edge service target before moving on to the next step.

### Mesh configs

You should be able to reach control-api through the edge dns name on startup. 
