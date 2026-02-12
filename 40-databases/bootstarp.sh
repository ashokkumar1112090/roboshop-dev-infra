#1/bin/bash          #shell-scripting concept


component = $1      #parameters passed bcz hardcoded for mongodb so 
yum install ansible -y
ansible-pull -U https://github.com/ashokkumar1112090/ansible-roboshop-roles.tf.git \
  -e component=$component \
  main.yaml

# git clone ansible-playbook
# cd ansible-playbook
# ansible-playbook -i inventory main.yaml