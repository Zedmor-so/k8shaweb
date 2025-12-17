#!/bin/bash
# Авто-определение подсети
SUBNET=$(./scripts/detect-subnet.sh)
echo "Auto subnet: $SUBNET"

# Установка с подстановкой
SUBNET=$SUBNET helm upgrade --install terrikon-app . \
  --set metallb.subnet=$SUBNET \
  --namespace default \
  --create-namespace

echo "✅ Installed! Service IP: $(kubectl get svc terrikon-app -o jsonpath='{.status.loadBalancer.ingress[0].ip}')"