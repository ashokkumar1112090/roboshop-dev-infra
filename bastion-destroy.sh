#!bin/bash 
set -e
BASE_PATH="/c/devops/daws-86s/repos/roboshop-dev-infra"

read -p "Are you sure destroyed   40-DATABASES IN BASTION? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
  echo "Destroy cancelled."
  exit 1
fi

cd $BASE_PATH/60-catalogue

if [ ! -d ".terraform" ]; then
  techo "Initializing Terraform..."
    terraform init -input=false
fi
terraform destroy -auto-approve
echo "60-catalogue   completed"

cd $BASE_PATH/40-databases

if [ ! -d ".terraform" ]; then
  techo "Initializing Terraform..."
    terraform init -input=false
fi
terraform destroy -auto-approve
echo "40-databases   completed"
