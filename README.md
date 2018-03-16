terraform-base
==============

Basic skeleton to build basic but complete environment on AWS. It is build around modules and with separation for `prod` / `staging` environments.

all state files and secret files are gitignored.

dependencies
------------

- terraform - `brew install terraform`
- fabric - `brew install fabric`

usage
-----

put your aws api keys into credentials file: `$HOME/.aws/credentials` accordingly to schema below:

```
[customer_name_1]
aws_access_key_id = <aws_api_key>
aws_secret_access_key = <aws_secret_key>

[customer_name_2]
aws_access_key_id = <aws_api_key>
aws_secret_access_key = <aws_secret_key>
```

and put desired profile name (one between [ ]) into `main.tf` file inside terraform /backend section/. In case of existing project please set profile name accordingly to existing name (read from `main.tf`).

To set whole project, go to `variables.tf` and fill out all needed fields - take a closer look on vars like `use_elb`, `use_rds` etc - these determines which AWS services needs to be set.


then use fabric:

`fab staging up`

for manual start:

`cd <$ENV>` and `terraform init`

to start terraform with custom variables go with:
`terraform plan -var-file="../vars_secrets.tfvars"`
