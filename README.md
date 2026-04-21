# Azure DevSecOps Platform
Cloud-native microservices platform on Azure — Terraform + AKS + Helm + Azure DevOps CI/CD
[![Pipeline Status](https://dev.azure.com/ramya-devsecops/azure-devsecops-platform/_apis/build/status/RamyaTejaswin.azure-devsecops-platform?branchName=main)](https://dev.azure.com/ramya-devsecops/azure-devsecops-platform/_build)
![Azure](https://img.shields.io/badge/Azure-0078D4?style=flat&logo=microsoftazure&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=flat&logo=kubernetes&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat&logo=terraform&logoColor=white)
![Helm](https://img.shields.io/badge/Helm-0F1689?style=flat&logo=helm&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)
![SonarQube](https://img.shields.io/badge/SonarQube-4E9BCD?style=flat&logo=sonarqube&logoColor=white)

A production-grade cloud-native microservices platform built on Microsoft Azure, demonstrating end-to-end DevSecOps practices including infrastructure automation, container orchestration, CI/CD pipelines, security scanning, and observability.

---

## Architecture Overview
┌─────────────────────────────────────────────────────────────┐
│                     Azure Cloud                              │
│                                                             │
│  ┌──────────┐    ┌──────────┐    ┌──────────────────────┐  │
│  │  GitHub  │───▶│  Azure   │───▶│      Azure AKS       │  │
│  │   Repo   │    │ DevOps   │    │  ┌────────────────┐  │  │
│  └──────────┘    │Pipelines │    │  │  api-gateway   │  │  │
│                  └──────────┘    │  │  auth-service  │  │  │
│                       │          │  │  data-service  │  │  │
│                       ▼          │  └────────────────┘  │  │
│                  ┌──────────┐    └──────────────────────┘  │
│                  │SonarQube │                               │
│                  │  Trivy   │    ┌──────┐  ┌───────────┐  │
│                  └──────────┘    │  ACR │  │ Key Vault │  │
│                                  └──────┘  └───────────┘  │
│                  ┌─────────────────────────────────────┐   │
│                  │  Azure Monitor + Log Analytics       │   │
│                  └─────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘

---

## Tech Stack

| Category | Tools |
|---|---|
| Cloud | Microsoft Azure (AKS, ACR, Key Vault, VNet, NSG, App Insights) |
| IaC | Terraform (modular), Bicep |
| CI/CD | Azure DevOps Pipelines (YAML multi-stage) |
| Containers | Docker (multi-stage builds), Kubernetes, Helm |
| Security | SonarQube, Trivy, RBAC, Azure Policy, Key Vault CSI |
| Monitoring | Azure Monitor, Log Analytics, Container Insights |
| Scripting | Bash, PowerShell |

---

## CI/CD Pipeline

The pipeline has 5 stages that run automatically on every push to `main`:
┌─────────┐    ┌───────────┐    ┌────────┐    ┌─────────┐    ┌──────┐
│  Build  │───▶│ SonarQube │───▶│ Trivy  │───▶│ Staging │───▶│ Prod │
│  & Push │    │ Code Scan │    │  Scan  │    │ Deploy  │    │Deploy│
└─────────┘    └───────────┘    └────────┘    └─────────┘    └──────┘
Docker          Code           Image        Helm +         Helm +
build +        quality       vulnerability  approval       manual
ACR push        gate            scan          gate         approval

### Pipeline Screenshots
![Pipeline All Green](docs/screenshots/week4-pipeline-green.png)

---

## Infrastructure (Terraform Modules)
terraform/
├── modules/
│   ├── aks/          # AKS cluster, node pools, RBAC
│   ├── networking/   # VNet, subnets, NSGs
│   ├── acr/          # Azure Container Registry
│   ├── keyvault/     # Key Vault + access policies
│   └── monitoring/   # Log Analytics + App Insights
└── envs/
├── dev/          # Dev environment config
└── prod/         # Prod environment config

**Remote state** stored in Azure Blob Storage with state locking.

---

## Microservices

| Service | Port | Responsibility |
|---|---|---|
| api-gateway | 8000 | Routes requests, entry point |
| auth-service | 8001 | Authentication, token generation |
| data-service | 8002 | Data layer, mock records |

Each service has:
- Multi-stage Dockerfile (builder + runtime)
- Kubernetes Deployment with resource limits
- HorizontalPodAutoscaler (min 2, max 5 replicas)
- Liveness + Readiness probes
- NetworkPolicy (namespace-scoped traffic)

---

## Security

- **Zero secrets in code** — all secrets injected via Azure Key Vault CSI driver
- **Image scanning** — Trivy scans every image for HIGH/CRITICAL CVEs before deploy
- **Code quality** — SonarQube quality gate blocks bad code from merging
- **RBAC** — least-privilege roles per namespace and resource group
- **Azure Policy** — enforces mandatory tagging on all resources
- **Defender for Cloud** — enabled on AKS cluster

---

## Monitoring

- **Container Insights** — pod health, CPU/memory per container
- **Log Analytics** — centralized logs with custom KQL queries
- **Azure Monitor alerts** — CPU > 80%, pod failures trigger alerts
- **Application Insights** — distributed tracing across services
- **Cost alerts** — budget alert at 80% of monthly limit

### Monitoring Dashboard
![Azure Monitor Dashboard](docs/screenshots/week5-monitoring.png)

---

## Key Results

| Metric | Result |
|---|---|
| Infrastructure provisioning time | Reduced from manual (hours) to Terraform (< 10 min) |
| Deployment time | End-to-end pipeline completes in ~25 minutes |
| Production uptime | 99.9% via AKS HPA + self-healing pods |
| Secrets in code | 0 — 100% Key Vault injected |
| Pipeline stages | 5 automated stages with approval gates |

---

## How to Deploy

### Prerequisites
- Azure CLI, Terraform, kubectl, Helm installed
- Azure subscription with Contributor access

### Deploy Infrastructure
```bash
cd terraform/envs/dev
terraform init
terraform plan
terraform apply
```

### Connect to AKS
```bash
az aks get-credentials \
  --resource-group rg-devops-dev \
  --name aks-devops-dev
kubectl get nodes
```

### Deploy Services
```bash
helm install api-gateway ./helm/api-gateway --namespace dev
helm install auth-service ./helm/auth-service --namespace dev
helm install data-service ./helm/data-service --namespace dev
```

---

## Project Timeline
**Oct 2024 – Apr 2025** | Self-directed DevOps upskilling project

---

## Author
**Ramya Tejaswini** | Azure DevOps Cloud Engineer 
