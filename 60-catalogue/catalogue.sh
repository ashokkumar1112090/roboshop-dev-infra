#/bin/bash          #shell-scripting concept


component=$1
environment=$2     #parameters passed bcz hardcoded for mongodb so 
yum install ansible -y
# ansible-pull -U https://github.com/ashokkumar1112090/ansible-roboshop-roles.tf.git \
#   -e component=$component \
#   main.yaml    its not respecting inventory.in file so fetching ip difficult so write conditions and cmds

# git clone ansible-playbook
# cd ansible-playbook
# ansible-playbook -i inventory main.yaml  


#variables declaring bcz DRY

REPO_URL=https://github.com/ashokkumar1112090/ansible-roboshop-roles.tf.git
REPO_DIR=/opt/roboshop/ansible        #cloning to this directory
ANSIBLE_DIR=ansible-roboshop-roles.tf  #after cloning


mkdir -p $REPO_DIR
mkdir -P /var/log
touch ansible.log

cd $REPO_DIR

#check if ansible cloned or not
if [ -d $ANSIBLE_DIR ]; then

   cd $ANSIBLE_DIR
   git pull
else
  git clone $REPO_URL
  cd $ANSIBLE_DIR
fi

echo "environment : $2" #just to recheck msg in output while executng
#no need of -inven bcz ansible.cfg lo echam
ansible-playbook -e component=$component -e env=$environment main.yaml