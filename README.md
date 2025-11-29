# ICIDAP: Intelligent Cloud-Native Incident Detection & Automation Platform

A cloud-native, AI-driven incident detection platform that ingests logs/metrics/network events, runs anomaly detection + LLM incident summarization, exposes REST/GraphQL/gRPC APIs, and is deployable locally/k3s (or AWS/GCP) with Terraform, Docker, CI/CD.

## Project Structure

```
icidap/
├─ infra/                  # Infrastructure as Code
│  ├─ k8s/                 # Helm charts & Kubernetes manifests
│  ├─ terraform/           # Cloud provisioning (AWS/GCP)
│  └─ argocd/              # GitOps configurations
├─ services/               # Backend Microservices
│  ├─ ingestion/           # High-throughput log/metric ingestion (FastAPI/Go)
│  ├─ anomaly-detection/   # ML-based anomaly detection engine (Python)
│  ├─ llm/                 # Generative AI incident summarization (Python)
│  ├─ incidents/           # Incident management & workflow logic (Go/Python)
│  └─ auth/                # Authentication & User Management
├─ web/                    # Frontend Applications
│  ├─ dashboard/           # Main Operation Center (React)
│  └─ admin/               # System Administration (React/Internal)
├─ libs/                   # Shared Libraries
│  ├─ common/              # Shared types, utils, and Protobuf definitions
│  └─ infra-tools/         # Custom tooling for infrastructure
├─ data/                   # Local datasets & synthetic data generators
├─ docs/                   # Documentation (Architecture, Runbooks)
├─ scripts/                # Dev & Ops scripts (setup, build, deploy)
└─ .github/                # CI/CD Pipelines
```

## Getting Started

### Prerequisites
- Docker
- Kind (Kubernetes in Docker)
- Helm

### 1. Setup Local Cluster
```bash
# Create cluster
kind create cluster --config infra/k8s/kind-config.yaml --name icidap-cluster

# Install Observability (Prometheus/Grafana/Loki)
./scripts/setup_observability.sh

# Install Messaging (Redpanda)
./scripts/setup_messaging.sh
```

### 2. Deploy Ingestion Service
```bash
# Build images
docker build -t icidap-ingestion:v1 ./services/ingestion
docker build -t icidap-load-gen:v1 ./services/load-gen

# Load into Kind
kind load docker-image icidap-ingestion:v1 --name icidap-cluster
kind load docker-image icidap-load-gen:v1 --name icidap-cluster

# Deploy
kubectl apply -f infra/k8s/ingestion-deployment.yaml
```

See `docs/runbook.md` for detailed setup instructions.
