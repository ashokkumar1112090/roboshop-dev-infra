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
echo "in bastion run 60-catalogue 40-db"

read -p "Are you sure created 40-databases in bastion? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
  echo "apply cancelled."
  exit 1
fi

cd $BASE_PATH/50-backend-alb
echo "Deploying 50-backend-alb.."
terraform apply -auto-approve
echo "50-backend-alb destroyed completed"

read -p "Are you sure created  60-catalogue in bastion? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
  echo "apply cancelled."
  exit 1
fi

cd $BASE_PATH/70-acm
echo "Deploying 70-acm.."
terraform apply -auto-approve
echo "70-acm apply completed"

cd $BASE_PATH/80-frontend-alb
echo "Deploying 80-frontend-alb.."
terraform apply -auto-approve
echo "80-frontend-alb apply completed"

