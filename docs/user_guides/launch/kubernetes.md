# Running Oumi on Kubernetes

Oumi supports running workloads on Kubernetes clusters through SkyPilot integration. This guide explains how to set up and use Kubernetes with Oumi.

## Prerequisites

1. A working Kubernetes cluster (self-managed or managed service like GKE, EKS, AKS)
2. `kubectl` configured with access to your cluster
3. Oumi installed with Kubernetes support: `pip install oumi[kubernetes]`

## Deployment Options

There are three ways to deploy Oumi on Kubernetes:

1. Using SkyPilot integration (recommended for development)
2. Using Helm charts (recommended for production)
3. Using Timoni modules (alternative to Helm)

### 1. Using SkyPilot Integration

The SkyPilot integration is the easiest way to get started. It handles all the Kubernetes resource management automatically.

1. Create a job configuration file (see [example](../../configs/recipes/kubernetes/quickstart_k8s_job.yaml))
2. Launch the job:
```bash
oumi launch up -c configs/recipes/kubernetes/quickstart_k8s_job.yaml
```

Key configuration options:
```yaml
resources:
  cloud: kubernetes  # Use Kubernetes as cloud provider
  kubernetes_config: ~/.kube/config  # Optional: custom kubeconfig path
  
  # Resource requirements
  cpus: 4
  memory: 16Gi
  accelerators: A100:1  # For GPU workloads
  
  # Node selection (optional)
  node_selector:
    cloud.google.com/gke-nodepool: gpu-pool
  
  # Tolerations for node taints (optional)
  tolerations:
    - key: "nvidia.com/gpu"
      operator: "Exists"
      effect: "NoSchedule"
```

### 2. Using Helm Charts

For production deployments, we recommend using the Helm chart:

1. Add the Oumi Helm repository:
```bash
helm repo add oumi https://oumi.ai/charts
helm repo update
```

2. Install Oumi:
```bash
# Basic CPU-only installation
helm install oumi oumi/oumi

# GPU-enabled installation
helm install oumi oumi/oumi --set deploymentSize=gpu

# Custom configuration
helm install oumi oumi/oumi -f values.yaml
```

See the [Helm chart documentation](../../helm/oumi/README.md) for all configuration options.

### 3. Using Timoni Modules

Timoni provides an alternative to Helm with better validation through CUE:

1. Install Timoni module:
```bash
timoni -n default install oumi oci://ghcr.io/oumi-ai/modules/oumi \
  --values values.cue
```

See the [Timoni module documentation](../../timoni/oumi/README.md) for configuration details.

## GPU Support

To use GPUs in your Kubernetes cluster:

1. Ensure the NVIDIA device plugin is installed:
```bash
kubectl create -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v0.14.1/nvidia-device-plugin.yml
```

2. Configure your job/deployment to request GPU resources:
```yaml
# In SkyPilot config:
resources:
  accelerators: A100:1

# In Helm values:
deploymentSize: gpu
gpuCount: 1

# In Timoni values:
resources:
  size: gpu
  gpuCount: 1
```

## Storage

Oumi supports various storage options on Kubernetes:

1. Persistent Volumes
2. Cloud Storage (S3, GCS, Azure Blob)
3. NFS
4. HostPath (not recommended for production)

Configure storage in your deployment:
```yaml
# Using SkyPilot
storage_mounts:
  models:
    source: s3://oumi-models/
    mount_path: /app/models

# Using Helm
persistence:
  enabled: true
  size: 100Gi
  storageClass: standard

# Using Timoni
storage:
  enabled: true
  size: 100Gi
  class: standard
```

## Monitoring

Oumi deployments can be monitored using standard Kubernetes tools:

1. Kubernetes Dashboard
2. Prometheus/Grafana
3. Cloud provider monitoring (GCP Operations, CloudWatch, Azure Monitor)

## Troubleshooting

Common issues and solutions:

1. Pod stuck in Pending
   - Check node resources
   - Verify node selectors/taints
   - Check PVC binding

2. GPU not available
   - Verify NVIDIA device plugin installation
   - Check node labels
   - Validate GPU driver installation

3. Storage issues
   - Check PVC status
   - Verify storage class exists
   - Check cloud storage credentials

For more help:
- Join our [Discord](https://discord.gg/oumi)
- File issues on [GitHub](https://github.com/oumi-ai/oumi)
- Check the [SkyPilot Kubernetes docs](https://docs.skypilot.co/en/latest/reference/kubernetes/)