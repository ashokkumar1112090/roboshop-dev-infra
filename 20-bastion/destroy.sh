set -e
BASE_PATH="/roboshop-dev-infra"

read -p "Are you sure destroyed 60-catalogue and IN BASTION? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
  echo "Destroy cancelled."
  exit 1
fi



cd $BASE_PATH/60-catalogue
if [ ! -d ".terraform" ]; then
  echo "Initializing Terraform..."
    terraform init -input=false
fi
terraform destroy -auto-approve
echo "60-catalogue completed destroyed"


read -p "Are you sure destroyed 50-backend-alb and IN gitbash? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
  echo "Destroy cancelled."
  exit 1
fi

cd $BASE_PATH/40-databases
if [ ! -d ".terraform" ]; then
  echo "Initializing Terraform..."
    terraform init -input=false
fi
terraform destroy -auto-approve
echo "40-databases completed destroyed"

echo " go to GITBASH destroy rem 30,20,10,00-vpc."
   