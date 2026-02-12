#!/bin/bash

set -e
BASE_PATH="/c/devops/daws-86s/repos/roboshop-dev-infra"

cd $BASE_PATH/30-sg-rules
terraform destroy -auto-approve

cd $BASE_PATH/20-bastion
terraform destroy -auto-approve

cd $BASE_PATH/10-sg
terraform destroy -auto-approve

cd $BASE_PATH/00-vpc
terraform destroy -auto-approve
