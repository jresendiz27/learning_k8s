# install kubernetes control-plane
# Control plane
if [[ $HOSTNAME = "control-plane"]]; then
    sudo kubeadm init --pod-network-cidr=172.16.1.0/16 --apiserver-advertise-address=$CONTROL_PLANE_IP --cri-socket=/var/run/crio/crio.sock

    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config

    kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
else
    echo "Insert the kubeadmn join command from the control-plane!!"
    # worker 
    sudo kubeadm join 192.168.56.4:6443 --token <TOKEN> --discovery-token-ca-cert-hash sha256:<HASH> --cri-socket=/var/run/crio/crio.sock
fi
