#!/bin/bash

set -e
BASE_PATH="/c/devops/daws-86s/repos/roboshop-dev-infra"

read -p "Are you sure destroying of total roboshop-dev-infra? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
  echo "Destroy cancelled."
  exit 1
fi

cd $BASE_PATH/80-frontend-alb
echo "destroying 80-frontend-alb"
if [ ! -d ".terraform" ]; then
  echo "Initializing Terraform..."
    terraform init -input=false
fi
terraform destroy -auto-approve
echo "80-frontend-alb completed destroyed"

cd $BASE_PATH/70-acm
echo "destroying 70-acm"
if [ ! -d ".terraform" ]; then
  echo "Initializing Terraform..."
    terraform init -input=false
fi
terraform destroy -auto-approve
echo "70-acm completed destroyed"


read -p "Are you sure destroyed 60-catalogue and IN BASTION? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
  echo "Destroy cancelled."
  exit 1
fi

cd $BASE_PATH/50-backend-alb
echo "destroying 50-backend-alb"
if [ ! -d ".terraform" ]; then
  techo "Initializing Terraform..."
    terraform init -input=false
fi
terraform destroy -auto-approve
echo "50-backend-alb completed"

read -p "Are you sure destroyed 40-databases and IN BASTION? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
  echo "Destroy cancelled."
  exit 1
fi



cd $BASE_PATH/30-sg-rules
echo "destroying 30-sgrules"
if [ ! -d ".terraform" ]; then
  techo "Initializing Terraform..."
    terraform init -input=false
fi
terraform destroy -auto-approve
echo "30-sg rules completed"

cd $BASE_PATH/20-bastion
if [ ! -d ".terraform" ]; then
  echo "Initializing Terraform..."
    terraform init -input=false
fi
terraform destroy -auto-approve
echo "20-bastion completed destroyed"

cd $BASE_PATH/10-sg
if [ ! -d ".terraform" ]; then
  echo "Initializing Terraform..."
    terraform init -input=false
fi
terraform destroy -auto-approve
echo "10-sg destroyed"

cd $BASE_PATH/00-vpc
if [ ! -d ".terraform" ]; then
  echo "Initializing Terraform..."
    terraform init -input=false
fi
terraform destroy -auto-approve


echo "Destroying  40-Databases...30-sg-rules..20-bastion...10-sg...00-vpc...destroyed...."


# 🔥 Combined Root Cause Summary (Your Case)

# Most likely scenario:

# You ran terraform apply

# It got interrupted OR network dropped

# Lock file stayed in S3

# You switched folders (10-sg, 20-bastion, 30-sg-rules)

# Backend keys differed

# You tried unlocking from wrong module

# Versioning in S3 caused 412 error

# Terraform local metadata was stale

# So multiple small issues combined created repeated lock error