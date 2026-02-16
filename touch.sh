#!/bin/bash

set -e   # stop script if any error comes

BASE_PATH="/c/devops/daws-86s/repos/roboshop-dev-infra"

echo "Starting RoboShop Dev Infra Deployment..."

# 00 - VPC
cd $BASE_PATH/00-vpc
echo "Deploying VPC..."
terraform apply -auto-approve
echo "vpc completed"

# 10 - Security Groups
cd $BASE_PATH/10-sg
echo "Deploying Security Groups..."
terraform apply -auto-approve
echo "security grp completed"

# 20 - Bastion
cd $BASE_PATH/20-bastion
echo "Deploying Bastion..."
terraform apply -auto-approve
echo "bastion completed"

# 30 - sg-rules
cd $BASE_PATH/30-sg-rules
echo "Deploying 30-sg-rules..."
terraform apply -auto-approve
echo "sg-rules completed"
 

echo "RoboShop Dev Infra Deployment of 00-vpc , 10-sg, 20-bastion, 30-sg-rules,  Completed Successfully!"
echo "in bastion run 60catalogue 40-db"