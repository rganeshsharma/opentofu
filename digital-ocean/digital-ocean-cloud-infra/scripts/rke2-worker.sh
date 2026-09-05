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