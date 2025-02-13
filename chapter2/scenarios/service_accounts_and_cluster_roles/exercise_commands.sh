
## create namespaces, roles and bindings
kubectl create namespace apps
cat api-cluster-role.yml && kubectl apply -f api-cluster-role.yml
cat cluster_role_binding.yml && kubectl apply -f cluster_role_binding.yml
cat service_account_token.yml && kubectl apply -f service_acconut_token.yml
cat service_account.yml && kubectl apply -f service_acconut.yml

# create containers
kubectl create namespace rm
cat nginx_pod.yml && kubectl apply -f nginx_pod.yml
cat disposable.yml && kubectl apply -f disposable.yml
# open an IT terminal to nginx operator in apps namepsace
kubectl exec -it operator -n apps -- /bin/sh
# curl the response using the api-access bearer token
TOKEN=$(kubectl create token api-access -n apps)
curl -X GET https://$(minikube ip):6443/api/v1/pods -H "Authorization: Bearer $TOKEN" --insecure --verbose