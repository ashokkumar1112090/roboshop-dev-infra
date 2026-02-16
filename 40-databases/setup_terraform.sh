#!/bin/bash
chmod +x setup_terraform.sh

# Exit if any command fails
set -e

echo "Updating system..."
sudo dnf update -y

echo "Installing required plugins..."
sudo dnf install -y dnf-plugins-core

echo "Adding HashiCorp repository..."
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo

echo "Installing Terraform..."
sudo dnf install -y terraform

echo "Terraform version:"
terraform -version

echo "Initializing Terraform project..."
terraform init -reconfigure

echo "terr apply command running"
terraform apply -auto-approve

echo "Done ✅ Terraform installed and initialized!"
