cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf overlay br_netfilter
EOF
modprobe overlay
modprobe br_netfilter
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sysctl --system
apt-get update
apt-get install -y apt-transport-https ca-certificates curl vim
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh 
systemctl restart docker
systemctl enable docker
sed -i 's/disabled/enable/' /etc/containerd/config.toml
sed -i 's/cri/containerd/' /etc/containerd/config.toml 
systemctl restart docker
systemctl restart containerd
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubelet kubeadm kubectl
source <(kubectl completion bash) 
echo "source <(kubectl completion bash)" >> ~/.bashrc
