#!/usr/bin/env bash

set -euo pipefail

echo "Install Prereqisites..." 
apt-get update

apt-get install -y \
    curl \
    ca-certificates \
    jq \
    apparmor \
    apparmor-utils

eco "Set Hostname " && sudo hostnamectl set-hostname ai-lab-platform-01

echo "App Armor Active?"
systemctl is-active apparmor

echo "Disabling swap immediately..." && sudo swapoff -a

echo "Disabling swap permanently..." && sudo sed -i '/ swap / s/^/#/' /etc/fstab

echo "Verify swap is off..." && free -h
# Swap line should show 0

# Load modules
echo "Load modules..." && sudo modprobe overlay && sudo modprobe br_netfilter

# Make modules load on boot
echo "Make modules load on boot..."
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

echo "Configuring Kernel Parameters..."
# Set sysctl parameters
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl parameters
sudo sysctl --system

# Verify
sudo sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward

echo "Stopping and Disabling UFW ..."
sudo systemctl stop ufw
sudo systemctl disable ufw

echo "Install kubectl..." && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
echo "Installed Kubectl client with version " && kubectl version --client

echo "Installing Helm..." && curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4
chmod 700 get_helm.sh
./get_helm.sh
echo "Installed Helm with version " && helm version
