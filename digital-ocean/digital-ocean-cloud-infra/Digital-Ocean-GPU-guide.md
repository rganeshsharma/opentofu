---
title: Recommended Drivers and Software for GPU Droplets
description: Follow our recommended setup for drivers and software on GPU Droplets to use their GPUs.
product: Droplets
url: https://docs.digitalocean.com/products/droplets/getting-started/recommended-gpu-setup/
last_updated: "2026-08-24"
---

> **For AI agents:** The documentation index is at [https://docs.digitalocean.com/llms.txt](https://docs.digitalocean.com/llms.txt). Markdown versions of pages use the same URL with `index.html.md` in place of the HTML page (for example, append `index.html.md` to the directory path instead of opening the HTML document).

# Recommended Drivers and Software for GPU Droplets

DigitalOcean Droplets are Linux-based virtual machines (VMs) that run on top of virtualized hardware. Each Droplet you create is a new server you can use, either standalone or as part of a larger, cloud-based infrastructure.

We strongly recommend creating GPU Droplets using our AI/ML-ready images, which have drivers and software preinstalled and configured to help you get started.

GPU Droplets also work with other Droplet images (stock Linux images, backups, snapshots, and so on) but you need to manually install drivers and other software to use your Droplet’s GPUs.

If you have additional software you want to use across multiple GPU Droplets, one option is to start with our AI/ML-ready image, install any additional software, and then [take a snapshot of the Droplet](https://docs.digitalocean.com/products/snapshots/how-to/snapshot-droplets/index.html.md). You can then use the snapshot as the base image to create additional GPU Droplets.

## AI/ML-Ready Image

### For AMD GPU Droplets

For GPU Droplets with AMD GPUs, our AI/ML-ready image is based on Ubuntu 24.04 and is configured following the [ROCm quick start setup](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/quick-start.html) including:

- `python3-setuptools`
- `python3-wheel`
- `rocm` version 7.14
- `amdgpu-dkms` version 6.19.14
- `amd-metrics-exporter` version 1.5.1
- `linux-generic`

You can choose this image when you create a GPU Droplet from the control panel or specify it by slug name when you create a GPU using the API or `doctl` using the slug `gpu-amd-base`.

### For NVIDIA GPU Droplets

For GPU Droplets with NVIDIA GPUs, our AI/ML-ready image is based on Ubuntu 24.04 and includes:

- [`cuda-keyring_1.1-1`](https://developer.nvidia.com/blog/updating-the-cuda-linux-gpg-repository-key/): configures access to NVIDIA’s CUDA Linux repository (not application software itself)
- `nvidia-driver-pinning-580`: pins the NVIDIA driver stack
- `cuda-toolkit-13-1`
- `nvidia-container-toolkit-1.19.1-1`
- `dcgm-exporter`: DCGM Exporter version 4.5.3-4.8.2 (not available as an APT package)
- `datacenter-gpu-manager-4-cuda13`: for DCGM Exporter

Additionally, 8 GPU Droplets include:

- `doca-roce`: DOCA 2.9.3
- `nvidia-fabricmanager`: 580.173.02
- `infiniband-diags`: 2410mlnx54-1.2410068
- `nvlink5`: 580.173.02
- `linux-generic`

You can choose this image when you create a GPU Droplet from the control panel or specify it by slug name when you create a GPU using the API or `doctl`. For all single GPU Droplets, use `gpu-h100x1-base` (even for single GPU plans using GPUs other than H100s). For 8 GPU Droplets, use `gpu-h100x8-base`.

For manual setup, on Debian-based systems like Ubuntu, you can install the CUDA drivers and toolkit as well as the NVIDIA Container Toolkit with APT. On 8 GPU Droplets, our image installs additional software that requires more configuration, as noted above. We recommend following [NVIDIA’s installation documentation for Fabric Manager](https://docs.nvidia.com/datacenter/tesla/fabric-manager-user-guide/index.html#installation) and [NVIDIA’s documentation on Mellanox OFED](https://docs.nvidia.com/networking/display/mlnxofedv461000/installing+mellanox+ofed).

## Inference-Optimized Image for NVIDIA GPU Droplets

Our [inference-optimized image](https://docs.digitalocean.com/products/droplets/details/features/index.html.md#gpu-images) is designed for LLM setup and deployment. It is based on Ubuntu 24.04 and includes:

- CUDA 12.9
- NVIDIA driver version 575.51.03
- NVIDIA Fabric Manager (8 GPU Droplets only)
- Docker
- [vLLM](https://github.com/vllm-project/vllm) (`vllm-openai` container v0.9.0)

You can choose this image when you create a GPU Droplet from the control panel.

After you create a GPU Droplet with this image, [SSH into the Droplet](https://docs.digitalocean.com/products/droplets/how-to/connect-with-ssh/index.html.md) as the **root** user and run the included `run_model.sh` script. The script prompts you through the configuration and selection of the models you want to use.