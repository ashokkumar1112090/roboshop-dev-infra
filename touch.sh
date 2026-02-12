#!/bin/bash

set -e   # stop script if any error comes

BASE_PATH="/c/devops/daws-86s/repos/roboshop-dev-infra"

echo "Starting RoboShop Dev Infra Deployment..."

# 00 - VPC
cd $BASE_PATH/00-vpc
echo "Deploying VPC..."
terraform apply -auto-approve

# 10 - Security Groups
cd $BASE_PATH/10-sg
echo "Deploying Security Groups..."
terraform apply -auto-approve

# 20 - Bastion
cd $BASE_PATH/20-bastion
echo "Deploying Bastion..."
terraform apply -auto-approve

# 30 - sg-rules
cd $BASE_PATH/30-databases
echo "Deploying Databases..."
terraform apply -auto-approve

echo "RoboShop Dev Infra Deployment of 00-vpc , 10-sg, 20-bastion, 30-sg-rules Completed Successfully!"
