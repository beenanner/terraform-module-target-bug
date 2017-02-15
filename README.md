##
test case for terraform -target module.somemodule fail

run this with 

```
terraform plan -target=module.cluster -var "aws_profile=your-profile-in-credentials" -var "aws_region=us-east-1" -var "env_name=dev"

```
