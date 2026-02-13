#!/bin/bash

set -e
BASE_PATH="/c/devops/daws-86s/repos/roboshop-dev-infra"

# 40 - Databases
cd $BASE_PATH/40-databases
terraform destroy -auto-approve

cd $BASE_PATH/30-sg-rules
terraform destroy -auto-approve

cd $BASE_PATH/20-bastion
terraform destroy -auto-approve

cd $BASE_PATH/10-sg
terraform destroy -auto-approve

cd $BASE_PATH/00-vpc
terraform destroy -auto-approve

echo "Destroying  40-Databases...30-sg-rules..20-bastion...10-sg...00-vpc...destroyed...."
