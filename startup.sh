minikube delete
minikube start --driver=docker --memory=8g --cpus=4
minikube addons enable ingress
minikube addons enable dashboard
minikube addons enable metrics-server
minikube addons enable registry

nohup kubectl port-forward -n kube-system service/registry 5000:80 > portforward.log 2>&1 &

docker buildx bake base-images --push
docker buildx bake application-images --push

kubectl create namespace cert-manager
kubectl create secret tls my-ca-secret \
  --cert=./certificate-authority/ca7.crt \
  --key=./certificate-authority/ca7.key \
  -n cert-manager

helmfile --file ./environments sync