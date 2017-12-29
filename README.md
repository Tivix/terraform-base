terraform-base
--------------

Basic skeleton to build basic but complete environment on AWS. It is build around modules and with separation for `prod` / `staging` environments.

all state files and secret files are gitignored.

usage
=====

put your aws api keys into file named `vars_secrets.tfvars` inside root directory.

file's format:
```
aws_access_key = "my-aws_access_key-value"
aws_secret_key = "my-aws_secret_key-value"
```

then:

`cd <$ENV>` and `terraform init`

to start terraform with custom variables go with:
`terraform plan -var-file="../vars_secrets.tfvars"`