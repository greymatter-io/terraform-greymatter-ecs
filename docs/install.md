# Install

Instructions on installing Grey Matter on ECS.

There are several options for installing. This repo contains a full installation including the creation of a VPC and subnets. The `greymatter` module can also be installed into an existing VPC.

## Environment

Create a file `gm.tfvars` that looks like the following:

```bash
aws_region             = "<aws region to install>"
key_pair_name          = "<existing key pair name for ssh>"
optimized_ami          = "<ecs optimized ami id for your region - found [here](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html#ecs-optimized-ami-linux)>"
docker_gm_credentials  = { "username" : "<greymatter docker email>", "password" : "<greymatter docker password>" }
aws_access_key_id      = "<aws access key id>"
aws_secret_access_key  = "<aws secret access key>"
```

and fill in the values inside of `<>`.

### Optional environment variables

Optionally, you can also set:

```bash
cluster_name           = "<name of Grey Matter ECS cluster to be created>"
dns_ns_name            = "<desired domain name for Grey Matter Route 53 Hosted Zones>"
ec2_instance_type      = "<ec2 instance type for ecs cluster>"
ec2_max_instances      = <max & desired number of ec2 instances for the ecs cluster>
ec2_min_instances      = <min number of ec2 instances for the ecs cluster>
```

Note that when specifying ec2 instances and instance type, the ecs tasks will fail if allowed resources are insufficient. See [the aws documentation](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/container-instance-eni.html#eni-trunking-supported-instance-types) on resources for instance types.

If not specified, they have the following defaults:

```bash
cluster_name           = "gm-cluster"
dns_ns_name            = "greymatter.dev"
ec2_instance_type      = "t3.xlarge"
ec2_max_instances      = 3
ec2_min_instances      = 0
```

## Certificates

TLS will be turned on for the Grey Matter services and sidecars upon install. We use the certificates specified in the [`gm/certs`](gm/certs) directory. The default certs checked in here are self-signed certificates not suitable for production. To customize these, replace the content of the `ca.crt`, `cert.crt` and `key.crt` files for the services. Note that they must stay in the same directories and must still be named `ca.crt`, `cert.crt` and `key.crt`.

If you are installing the `greymatter` module into an existing VPC, follow the instructions [below](#grey-matter-module).

## Full Installation

Save your `gm.tfvars` file in the root directory of this repo and run:

```bash
terraform apply -var-file=gm.tfvars
```

Next, [configure the mesh](#configure-the-mesh).

## Grey Matter Module

To install the `greymatter` module into an existing VPC, add the following to your tf code:

```tf
module "greymatter" {
  source                 = "git::ssh://git@github.com/greymatter-io/terraform-greymatter-ecs//greymatter?ref=master"
  key_pair_name          = "<existing key pair name for ssh>"
  vpc_id                 = "<id of existing vpc to install in>"
  public_subnets         = <list of existing public subnets of vpc>
  private_subnets        = <list of existing private subnets of vpc>
  aws_region             = "<aws region to install>"
  optimized_ami          = "<ecs optimized ami id for your region - found [here](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html#ecs-optimized-ami-linux)>"
  docker_gm_credentials  = { "username" : "<greymatter nexus email>", "password" : "<greymatter nexus password>" }
  aws_access_key_id      = "<aws_access_key_id>"
  aws_secret_access_key  = "<aws_secret_access_key>"
}

output "gm_edge_dns" {
  value = module.greymatter.edge_dns
}
```

> Note: if you want to specify any [optional variables](#optional-environment-variables), include them in the module in the form `<var_name> = <value>`.

**Before installing, you must** copy the [`gm`](gm) directory into the location you are running `terraform apply` from. You can replace the certificates with your own as per [these instructions](#certificates).

For the following command, the directory structure should look like:

```bash
/
├── your-terraform.tf
├── gm
│   ├── certs
│       ├── control
│           ├── ca.crt
│           ├── cert.crt
│           ├── key.crt
│       ├── control-api
│           ├── ca.crt
│           ├── ...
│       ├── sidecar
│           ├── ca.crt
│           ├── ...
│       ...
│   ├── mesh
│       ├── apply.sh
│       ├── control-api
│           ├── cluster
│           ├── domain
│           ├── listener
│           ├── proxy
│           ├── route
```

To install, run:

```bash
terraform apply
```

then, [configure the mesh](#configure-the-mesh).

### Configure the Mesh

Once you have applied the terraform code, you should see the edge dns name output.

You should be able to reach control-api through the edge dns name on startup. Once the edge target group registered target is healthy, navigate to `http://{edge-dns}:10808/services/control-api/latest/` to verify this.

Once you can reach control-api, configure the cli, filling in {edge_dns}:

```bash
export GREYMATTER_API_HOST={edgs_dns}:10808
export GREYMATTER_API_INSECURE=true
export GREYMATTER_API_PREFIX=/services/control-api/latest
export GREYMATTER_API_SSL=false
export GREYMATTER_CONSOLE_LEVEL=debug
```

and run `./gm/mesh/apply.sh`.  This will apply the proper mesh configs for edge -> control-api-sidecar -> control-api through with ssl. It will also delete the old routes directly from edge to control-api-service. The CLI should still be properly configured.
