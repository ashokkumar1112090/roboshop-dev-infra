#!/bin/bash

set -e
BASE_PATH="/c/devops/daws-86s/repos/roboshop-dev-infra"

read -p "Are you sure destroyed   40-DATABASES IN BASTION? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
  echo "Destroy cancelled."
  exit 1
fi


# 40 - Databases
cd $BASE_PATH/40-databases

if [ ! -d ".terraform" ]; then
    echo "Initializing Terraform..."
    terraform init -input=false
  fi

terraform destroy -auto-approve

cd $BASE_PATH/30-sg-rules

if [ ! -d ".terraform" ]; then
  techo "Initializing Terraform..."
    terraform init -input=false
fi
terraform destroy -auto-approve

cd $BASE_PATH/20-bastion
if [ ! -d ".terraform" ]; then
  echo "Initializing Terraform..."
    terraform init -input=false
fi
terraform destroy -auto-approve

cd $BASE_PATH/10-sg
if [ ! -d ".terraform" ]; then
  echo "Initializing Terraform..."
    terraform init -input=false
fi
terraform destroy -auto-approve

cd $BASE_PATH/00-vpc
if [ ! -d ".terraform" ]; then
  echo "Initializing Terraform..."
    terraform init -input=false
fi
terraform destroy -auto-approve

echo "Destroying  40-Databases...30-sg-rules..20-bastion...10-sg...00-vpc...destroyed...."
ech