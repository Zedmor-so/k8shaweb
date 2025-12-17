#!/bin/bash
# Автоопределение подсети
NETWORK=$(ip -4 addr show | grep -oP 'inet \K[\d.]+/[0-9]+' | grep -v 127.0.0.1 | grep -v 10.244 | head -1 | cut -d/ -f1 | cut -d. -f1-3)
SUBNET="${NETWORK}.245-${NETWORK}.250"

echo "Network: $NETWORK, Pool: $SUBNET"

# Создаем MetalLB пул и advertisement
cat <<EOF | kubectl apply -f -
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: auto-pool
  namespace: metallb-system
spec:
  addresses:
  - $SUBNET
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: l2adv
  namespace: metallb-system
spec:
  ipAddressPools:
  - auto-pool
EOF

# Деплоим приложение
kubectl apply -f autoscaling-lb-web.yaml

echo "✅ Deployed! Service IP: $(kubectl get svc terrikon-app-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}')"
