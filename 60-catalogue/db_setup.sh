#!/bin/bash

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
