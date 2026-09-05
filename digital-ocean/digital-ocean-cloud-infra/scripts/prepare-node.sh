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