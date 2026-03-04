#!/bin/bash
# chmod +x bastion.sh

for i in 00-vpc/ 10-sg/ 20-bastion/ 30-sg-rules/ 50-backend-alb/ 70-acm/ 80-frontend-alb/; do cd $i; terraform apply -auto-approve; cd .. ;done

# growing the /home volume for terraform purpose
sudo growpart /dev/nvme0n1 4
sudo lvextend -L +30G /dev/mapper/RootVG-homeVol
sudo xfs_growfs /home

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform

terraform init
terraform apply -auto-approve

cd ../90-components
terraform init
terraform apply -auto-approve

# sudo lvreduce -r -L 6G /dev/mapper/RootVG-rootVol
# for i in 40-databases /90-components/; do cd $i; terraform init; terraform apply -auto-approve; cd .. ;done
# creating databases
cd /home/ec2-user
git clone https://github.com/ashokkumar1112090/roboshop-dev-infra.git
chown ec2-user:ec2-user -R roboshop-dev-infra
cd roboshop-dev-infra/40-databases
terraform init
terraform apply -auto-approve

read -p "Are you sure 50-backend-alb launched in  your pc  (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
  echo " after 40-db enex 50-be alb next 60-cat"
  exit 1
fi



