#!/bin/bash
# chmod +x bastion.sh
# growing the /home volume for terraform purpose

read -p "Are you sure increased 50gdb vol in aws check it once ? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
  echo "db script to inc db of bastion running."
  exit 1
fi

sudo lsblk
sudo growpart /dev/nvme0n1 4
sudo lsblk 
sudo lvextend -L +30G /dev/mapper/RootVG-homeVol
sudo xfs_growfs /home


sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform

# creating databases
cd /home/ec2-user
git clone https://github.com/daws-86s/roboshop-dev-infra.git
chown ec2-user:ec2-user -R roboshop-dev-infra
cd roboshop-dev-infra/40-databases
terraform init
terraform apply -auto-approve

read -p "Are you sure 50-backend-alb launched in  your pc  (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
  echo " after 40-db enex 50-be alb next 60-cat"
  exit 1
fi



