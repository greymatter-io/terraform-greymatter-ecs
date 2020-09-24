# terraform-greymatter-ecs

Grey Matter Terraform Code to Deploy Grey Matter using AWS ECS

## Pre-install

1. Create 2 parameters in AWS systems manager paremeter store. One named `access_key` with type Secured String and the value the aws access key for your profile. Name the second `secret_access_key` and Secured String value of the corresponding secret access key id. Copy the arns and pass them to terraform as variables `access_key_arn` and `secret_access_key_arn`.

2. Run `aws kms describe-key --key-id alias/aws/ssm`, copy the Arn and set it as variable `kms_ssm_arn`.

3. Run `aws kms describe-key --key-id alias/aws/secretsmanager`, copy the Arn and set it as variable `kms_secretsmanager_arn`.

Look through the remaining [variables](greymatter/variables.tf) and make sure to enter the correct values.

## Install

Create a var file that looks like the following:

```bash
access_key_arn         = "{output of step 1 in pre-install}"
secret_access_key_arn  = "{output of step 1 in pre-install}"
aws_region             = "{region}"
key_pair_name          = "{name of existing keypair for ssh}"
kms_ssm_arn            = "{output of step 3 in pre-install}"
kms_secretsmanager_arn = "{output of step 4 in pre-install}"
optimized_ami          = "{ecs optimized ami - found [here](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html) }"
docker_gm_credentials  = {"username": "{greymatter-nexus-email}", "password": "{greymatter-nexus-password}"}
```

To install the mesh:

```bash
terraform apply -var-file=varfile.tfvars
```

When applied, the edge dns name should be output. Give the target group ~10 min to register the edge service target before moving on to the next step.

### Mesh configs

You should be able to reach control-api through the edge dns name on startup. Once the edge target group registered target is healthy, navigate to `http://{edge-dns}:10808/services/control-api/latest/` to verify this.

Once you can reach control-api, configure the cli, filling in {edge_dns}:

```bash
export GREYMATTER_API_HOST={edgs_dns}:10808
export GREYMATTER_API_INSECURE=true
export GREYMATTER_API_PREFIX=/services/control-api/latest
export GREYMATTER_API_SSL=false
export GREYMATTER_CONSOLE_LEVEL=debug
```

and run `./mesh/apply.sh`.  This will apply the proper mesh configs for edge -> control-api-sidecar -> control-api through with ssl. It will also delete the old routes directly from edge to control-api-service. The CLI should still be properly configured.
