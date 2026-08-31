# Digital Ocean Inference System

## Digital Ocean self managed RKE2 Inference System Architecture:

```
![Alt Text]digital-ocean-inferecne-system/opentofu/arch.svg
```

## RKE2 Architecture

```
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
                                   32 GB RAM
  RKE2 Server                      500 GB NVMe
  etcd
  ArgoCD                           RKE2 Agent
  Envoy Gateway                    GPU Operator
  cert-manager                     NVIDIA Toolkit
  Prometheus                       Device Plugin
  Grafana                          DCGM
                                   vLLM
                                   SGLang
                                   TensorRT-LLM

# Note: We are not using DOKS cluster for cost savings, ideally for a PROD setup always choose a managed K8s distrubution, in this case Digital ocean Kubernetes Service 

```

# Diretory structure:

```
infra/
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
└── cloud-init/
    ├── rke2-server.yaml
    └── rke2-agent.yaml
```