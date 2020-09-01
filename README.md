# terraform-greymatter-ecs
Grey Matter Terraform Code to Deploy Grey Matter using AWS ECS

1. Create 2 parameters in AWS systems manager paremeter store. One named `access_key` with type Secured String and the value the aws access key   for your profile. Name the second `secret_access_key` and Secured String value of the corresponding secret access key id. Copy the arns for step 2, **and** pass them to terraform as variables `access_key` and `secret_access_key`.

2. Create an IAM policy with:

    ```json
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "ssm:GetParameters",
                    "kms:Decrypt"
                ],
                "Resource": [
                    "{arn of access_key_parameter}",
                    "{arn of secret_access_key_parameter}",
                    "{arn of aws/ssm key in AWS KMS}"
                ]
            }
        ]
    }
    ```

    Attach it to your `ecsServiceRole` and `ecsTaskExecutionRole`

3. Create a secret with docker credentials for greymatter nexus. (Secret is type `Other`, add key `username` with value docker username, key `password` with value docker password). Copy the secret arn for step 4 **and** pass the arn to terraform as variable `docker_secret_arn`.

4. Create an IAM policy with:

    ```json
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "kms:Decrypt",
                    "secretsmanager:GetSecretValue"
                ],
                "Resource": [
                    "{arn of docker credentials secret}",
                    "{arn of aws/secretsmanager key in AWS KMS}"
                ]
            }
        ]
    }
    ```

    and attach it to the `ecsTaskExecutionRole`.

Look through the remaining variables in variables.tf and make sure to enter the correct values.
