# Certificate Management Details

The system uses cert-manager with a custom Certificate Authority. Here's the complete setup:

### 1. Install Cert-Manager
```yaml
- name: cert-manager
  namespace: cert-manager
  createNamespace: true
  version: v1.18.2
  chart: oci://quay.io/jetstack/charts/cert-manager
  verify: true
  keyring: ./cert-manager-keyring-2021-09-20-1020CF3C033D4F35BAE1C19E1226061C665DF13E.gpg
  values:
  - crds:
      enabled: true
```

### 2. Create ClusterIssuer
```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: my-ca-issuer
spec:
  ca:
    secretName: my-ca-secret
    secretNamespace: cert-manager
```

### 3. Create Certificate for Each Application
```yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: hello-tls
  namespace: default
spec:
  commonName: hello.local
  secretName: hello-local-tls-secret
  dnsNames:
    - www.hello.local
  issuerRef:
    name: my-ca-issuer
    kind: ClusterIssuer
```

### 4. Configure Ingress with TLS
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: hello-nginx
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: my-ca-issuer
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
spec:
  tls:
    - hosts:
        - hello.local
      secretName: hello-local-tls-secret
  rules:
    - host: hello.local
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: hello-nginx
                port:
                  number: 80
```
