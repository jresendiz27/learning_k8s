minikube stop || minikube start -n 3 --network-plugin=cni --cni=calico --apiserver-port=6443 --driver=kvm2
minikube addons enable metrics-server