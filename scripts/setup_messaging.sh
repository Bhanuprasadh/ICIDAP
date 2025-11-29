#!/bin/bash
set -e

echo "🚀 Setting up Messaging System (Redpanda)..."

# 1. Add Redpanda Helm Repository
echo "📦 Adding Redpanda Helm repository..."
helm repo add redpanda https://charts.redpanda.com
helm repo update

# 2. Create Namespace
echo "📂 Creating 'messaging' namespace..."
kubectl create namespace messaging --dry-run=client -o yaml | kubectl apply -f -

# 3. Install Redpanda (Single Node for Local Dev)
echo "🐼 Installing Redpanda (Single Node)..."
# We disable the tiered storage and resource requirements for a lightweight local setup
helm upgrade --install redpanda redpanda/redpanda \
  --namespace messaging \
  --set statefulset.replicas=1 \
  --set tuning.tune_aio_events=false \
  --set resources.cpu.cores=0.5 \
  --set resources.memory.container.min=2Gi \
  --set resources.memory.container.max=2Gi \
  --set tls.enabled=false \
  --set external.enabled=false \
  --wait

# 4. Install Redpanda Console (UI)
echo "🖥️ Installing Redpanda Console..."
helm upgrade --install redpanda-console redpanda/console \
  --namespace messaging \
  --set config.kafka.brokers=redpanda.messaging.svc.cluster.local:9093 \
  --set config.schemaRegistry.enabled=false \
  --wait

echo "✅ Messaging system deployed successfully!"
echo "------------------------------------------------"
echo "🔍 Access Redpanda Console:"
echo "   kubectl port-forward svc/redpanda-console 8080:8080 -n messaging"
echo "   URL: http://localhost:8080"
