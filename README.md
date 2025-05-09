## Cd into component folder
cd iac/rg-azug-demo/

## Init Terraform
terraform init -input=false -backend-config=./tf-backend/backend.development.json

## Plan Terraform
terraform plan -input=false -var-file=./variables/development.tfvars -out=./tfplan.out

## Plan Terraform
terraform apply "./tfplan.out"

## TF required version
required_version = ">= 1.3.0"