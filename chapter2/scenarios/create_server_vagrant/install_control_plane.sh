# install kubernetes control-plane
sudo swapoff -a
sudo modprobe br_netfilter
sudo sysctl -w net.ipv4.ip_forward=1

sudo systemctl enable --now kubelet

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# Control plane
sudo kubeadm init --pod-network-cidr=192.168.56.0/24 --apiserver-advertise-address=192.168.56.4 --cri-socket=/var/run/crio/crio.sock
# worker 
sudo kubeadm join 192.168.56.4:6443 --token <TOKEN> --discovery-token-ca-cert-hash sha256:<HASH> --cri-socket=/var/run/crio/crio.sock