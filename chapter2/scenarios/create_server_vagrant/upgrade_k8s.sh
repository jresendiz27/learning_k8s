export KUBERNETES_VERSION=v1.31
export CRIO_VERSION=v1.31

curl -fsSL https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring_$KUBERNETES_VERSION.gpg
sudo echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/stable:/$CRIO_VERSION/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring_$CRIO_VERSION.gpg
sudo echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://pkgs.k8s.io/addons:/cri-o:/stable:/$CRIO_VERSION/deb/ /" | sudo tee /etc/apt/sources.list.d/cri-o.list

sudo apt update
sudo apt-cache madison kubeadm
sudo apt-mark unhold kubeadm && sudo apt-get update && sudo apt-get install -y kubeadm=<VERSION_FROM_APT_CACHE_MADISON> && sudo apt-mark hold kubeadm
sudo kubeadm upgrade plan
sudo kubeadm upgrade apply v1.31.6
kubectl drain $HOSTNAME --ignore-daemonsets
sudo apt-cache policy kubelet kubectl
sudo apt-mark unhold kubelet kubectl && sudo apt install -y kubelet=<VERSION_FROM_APT_CACHE_MADISON> kubectl=<VERSION_FROM_APT_CACHE_MADISON> && sudo apt-mark hold kubelet kubectl
sudo systemctl daemon-reload
sudo systemctl restart kubelet
kubectl uncordon $HOSTNAME

## in the worker nodes is the same up to kubectl and kubelet reload
sudo apt update
sudo apt-cache madison kubeadm
sudo apt-mark unhold kubeadm && sudo apt-get update && sudo apt-get install -y kubeadm=<VERSION_FROM_APT_CACHE_MADISON> && sudo apt-mark hold kubeadm
sudo kubeadm upgrade node
### drain on the control plane: kubectl drain worker-1 --ignore-daemonsets
sudo apt-mark unhold kubelet kubectl && sudo apt install kubelet=<VERSION_FROM_APT_CACHE> kubectl=<VERSION_FROM_APT_CACHE> && sudo apt-mark hold kubelet kubectl && sudo systectl daemon-reload && sudo service kubelet restart
### uncordon on the control plane: kubectl uncordon worker-1
