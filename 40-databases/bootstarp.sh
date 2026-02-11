#1/bin/bash          #shell-scripting concept
dnf install ansible -y
ansible-pull -U https://github.com/ashokkumar1112090/ansible-roboshop-roles.tf.git -e component=mongodb main.yaml
# git clone ansible-playbook
# cd ansible-playbook
# ansible-playbook -i inventory main.yaml