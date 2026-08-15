#!/bin/bash
set -e

echo "Starting hardening..."

sudo apt-get update -y
sudo apt-get upgrade -y

# Install auditing
sudo apt-get install -y auditd
sudo systemctl enable auditd
sudo systemctl start auditd

# Disable direct root SSH login
sudo sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

# Disable password-based SSH authentication
sudo sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config

# Restart SSH
sudo systemctl restart ssh

# Remove unused packages
sudo apt-get autoremove -y
sudo apt-get clean

echo "Hardening completed."