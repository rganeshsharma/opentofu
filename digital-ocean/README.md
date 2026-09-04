# Digital Ocean Loacl LLM Inference Benchmarking System
## Design Blueprint:

```bash
Infrastructure
├── OpenTofu
├── DO VPC
├── NAT
├── Firewall
├── CPU Platform Node
└── GPU Worker

Kubernetes
├── RKE2
├── Cilium
├── Gateway API
├── Envoy Gateway
└── cert-manager

GPU
├── NVIDIA Driver
├── Container Toolkit
├── GPU Operator
├── DCGM Exporter
└── Node Feature Discovery

Observability
├── Prometheus
├── Grafana
└── OpenTelemetry

MLOps
├── MLflow
└── S3

Model Serving
├── vLLM
├── Triton
└── KServe

GenAI
├── FastAPI
├── Embedding model
├── Qdrant
├── RAG
├── MCP
└── Agent

GitOps
├── Git
└── ArgoCD
```


## Digital Ocean self managed RKE2 Inference System Architecture:

![HLD-Architecture]digital-ocean-inferecne-system/opentofu/arch.svg

```bash
DigitalOcean VPC
│
├── CPU Node
│   └── RKE2 Server
│       ├── Kubernetes control plane
│       ├── etcd
│       ├── Argo CD
│       ├── Envoy Gateway
│       ├── cert-manager
│       ├── Prometheus
│       └── Grafana
│
└── GPU Node
    └── RKE2 Agent
        ├── NVIDIA Driver
        ├── Container Toolkit
        ├── GPU Operator components
        ├── Device Plugin
        ├── DCGM Exporter
        │
        └── vLLM / SGLang / TRT-LLM
             └── RTX 4000 Ada 20 GB
```


## RKE2 PROD like Inference Architecture:

```bash
                    DIGITALOCEAN
                         │
                    Private VPC
                         │
          ┌──────────────┴───────────────┐
          │                              │
          ▼                              ▼
  CPU PLATFORM NODE                GPU WORKER
  ─────────────────                ───────────────
  4 vCPU                           RTX 4000 Ada
  8 GB RAM                         20 GB VRAM
  ~60 GB disk                      8 vCPU
Platform :                         32 GB RAM
  RKE2 Server                      500 GB NVMe
  etcd                           GPU Platform :
  ArgoCD                           RKE2 Agent
  Envoy Gateway                    GPU Operator
  cert-manager                     NVIDIA Toolkit
  Prometheus                       Device Plugin
  Grafana                          DCGM
  RAGS                             vLLM
                                   SGLang
                                   TensorRT-LLM

# Note: We are not using DOKS cluster for cost savings, ideally for a PROD setup always choose a managed K8s distrubution, in this case Digital ocean Kubernetes Service 

```

## Diretory structure:

```bash
digital-ocean-cloud-infra/
│
├── modules/
│   ├── vpc/
│   ├── cpu-node/
│   ├── gpu-node/
│   ├── firewall/
│   └── storage/
│
├── environments/
│   └── lab/
│       ├── network.tf
│       ├── control-plane.tf
│       ├── gpu-worker.tf
│       └── variables.tf
│
└── init/
    ├── rke2-server.yaml
    └── rke2-agent.yaml
```

## Deployment Flow:


```bash
tofu apply
     ↓
CPU Node created
     ↓
RKE2 control plane created
     ↓
GPU worker created
     ↓
RKE2 agent joins automatically
     ↓
ArgoCD installs platform
     ↓
GPU Operator installs
     ↓
vLLM deploys

#NOTE: Store the opentofu state in Digital Ocean Spaces Bucket and lock in backend config like:
use_lockfile = true 
```

## Destruction after implementing :

```bash
tofu destroy
```


## GitHub Flow:
```bash
GitHub/GitLab
│
├── Terraform/OpenTofu
├── Helm values
├── ArgoCD Applications
├── Gateway API manifests
├── GPU Operator configs
├── vLLM manifests
└── monitoring dashboards

# NOTE: Destroy/Create a new cluster and ArgoCD reconstructs the platform.
```
## Models weights Storage:
### Don't Download the model every single time:
```bash

create GPU
    ↓
download 20-50 GB model
    ↓
destroy GPU
    ↓
repeat downloading models again

```
### Use Persistent DigitalOcean Volume for mounting them in PoD directly
```bash
       │
       └── model-cache/
              ↓
        GPU Droplet
```
```
NOTE: DigitalOcean Volumes are network-attached block storage and can be detached/moved between compatible Droplets.
https://docs.digitalocean.com/products/volumes/how-to/create/?utm_source=chatgpt.com
```

## Taint Nodes:

```bash
# CPU Control Plane
node-role.kubernetes.io/control-plane=true

# taint:
node-role.kubernetes.io/control-plane:NoSchedule
nvidia.com/gpu.present: "true"
node.kubernetes.io/workload: gpu
```

### vLLM Config:
```bash
resources:
  limits:
    nvidia.com/gpu: 1

nodeSelector:
  node.kubernetes.io/workload: gpu
```


## GPU Operator architecture:

```
NOTE: The GPU Operator runs a number of DaemonSets.

You don't want driver/toolkit workloads trying to initialize on your CPU-only node.

NVIDIA's components and Node Feature Discovery identify eligible GPU nodes, and the actual GPU-specific pieces run on the GPU worker.
```

```bash
CPU NODE                   GPU NODE
────────                   ────────

RKE2 Server                RKE2 Agent

NFD Worker                 NFD Worker
                              │
                              ↓
                         GPU detected
                              │
                    ┌─────────┴─────────┐
                    │                   │
                Driver              Toolkit
                    │                   │
                    └─────────┬─────────┘
                              ↓
                       Device Plugin
                              ↓
                         DCGM Exporter
```

## Gateway Incoming request flow:

```bash
Laptop
   │
   ↓
Public IP
   │
CPU node
   │
Envoy Gateway
   │
HTTPRoute
   │
   └───────────────────┐
                       ↓
                   vLLM Service
                       │
                       ↓
                   vLLM Pod
                       │
                   GPU worker
                       │
                  RTX 4000
```

