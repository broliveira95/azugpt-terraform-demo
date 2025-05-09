## Cd into component folder
cd iac/rg-azug-demo/

## Init Terraform
terraform init -input=false -backend-config=./tf-backend/backend.development.json

## Plan Terraform
terraform plan -input=false -var-file=./variables/development.tfvars

## Plan Terraform
terraform apply -input=false -var-file=./variables/development.tfvars