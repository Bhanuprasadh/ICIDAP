#!/bin/bash
set -e

echo "🚀 Setting up Observability Stack (Prometheus, Grafana, Loki)..."

# 1. Add Helm Repositories
echo "📦 Adding Helm repositories..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# 2. Create Namespace
echo "📂 Creating 'observability' namespace..."
kubectl create namespace observability --dry-run=client -o yaml | kubectl apply -f -

# 3. Install Kube Prometheus Stack (Prometheus + Grafana)
echo "🔥 Installing Kube Prometheus Stack..."
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  --namespace observability \
  --set grafana.adminPassword='admin' \
  --wait

# 4. Install Loki (Log Aggregation)
echo "🪵 Installing Loki..."
helm upgrade --install loki grafana/loki-stack \
  --namespace observability \
  --set promtail.enabled=true \
  --set grafana.enabled=false \
  --wait

echo "✅ Observability stack deployed successfully!"
echo "------------------------------------------------"
echo "🔍 Access Grafana:"
echo "   kubectl port-forward svc/prometheus-grafana 3000:80 -n observability"
echo "   URL: http://localhost:3000"
echo "   User: admin"
echo "   Pass: admin"
