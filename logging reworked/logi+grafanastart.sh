kubectl create namespace monitoring && kubectl create namespace prod
helm repo add grafana https://grafana.github.io/helm-charts && helm repo update
helm install --values loki-values.yml loki grafana/loki -n monitoring
helm install --values grafana-values.yml grafana grafana/grafana --namespace monitoring
helm install --namespace monitoring alloy-logs grafana/alloy
kubectl apply -f config.alloy
helm upgrade --namespace monitoring alloy-logs grafana/alloy -f alloy-values.yaml
