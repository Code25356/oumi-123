# Oumi Helm Chart

This Helm chart deploys Oumi, an AI model serving platform, on a Kubernetes cluster.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- For GPU support: NVIDIA GPU Operator installed on the cluster

## Installing the Chart

To install the chart with the release name `my-oumi`:

```bash
helm install my-oumi ./helm/oumi
```

## Configuration

The following table lists the configurable parameters of the Oumi chart and their default values.

### Global Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repository` | Image repository | `oumi` |
| `image.tag` | Image tag | `latest` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `replicaCount` | Number of replicas | `1` |
| `deploymentSize` | Size of deployment (small/medium/large/gpu) | `medium` |

### Deployment Sizes

The chart supports different deployment sizes:

#### Small (CPU)
```yaml
requests:
  cpu: "1"
  memory: "4Gi"
limits:
  cpu: "2"
  memory: "8Gi"
```

#### Medium (CPU) - Default
```yaml
requests:
  cpu: "2"
  memory: "8Gi"
limits:
  cpu: "4"
  memory: "16Gi"
```

#### Large (CPU)
```yaml
requests:
  cpu: "4"
  memory: "16Gi"
limits:
  cpu: "8"
  memory: "32Gi"
```

#### GPU
```yaml
requests:
  cpu: "2"
  memory: "8Gi"
  nvidia.com/gpu: "1"
limits:
  cpu: "4"
  memory: "16Gi"
  nvidia.com/gpu: "1"
```

### Service Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `service.type` | Service type | `ClusterIP` |
| `service.port` | Service port | `8000` |
| `service.annotations` | Service annotations | `{}` |

### Ingress Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.enabled` | Enable ingress | `false` |
| `ingress.className` | Ingress class name | `""` |
| `ingress.annotations` | Ingress annotations | `{}` |
| `ingress.hosts` | Ingress hosts configuration | `[]` |
| `ingress.tls` | Ingress TLS configuration | `[]` |

### Persistence Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `persistence.enabled` | Enable persistence | `true` |
| `persistence.storageClass` | Storage class | `""` |
| `persistence.size` | Storage size | `100Gi` |
| `persistence.accessMode` | Access mode | `ReadWriteOnce` |

### Application Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `config.logLevel` | Application log level | `INFO` |
| `config.device` | Device to use (auto/cpu/cuda) | `auto` |
| `config.numWorkers` | Number of workers | `2` |

### Other Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `nodeSelector` | Node selector | `{}` |
| `tolerations` | Tolerations | `[]` |
| `affinity` | Affinity rules | `{}` |
| `podAnnotations` | Pod annotations | `{}` |
| `podLabels` | Additional pod labels | `{}` |

## Example Values Files

### CPU Deployment
```yaml
deploymentSize: medium
persistence:
  enabled: true
  size: 100Gi
config:
  device: "cpu"
```

### GPU Deployment
```yaml
deploymentSize: gpu
persistence:
  enabled: true
  size: 200Gi
config:
  device: "cuda"
nodeSelector:
  nvidia.com/gpu: "present"
```

## Testing

To test the deployment:

```bash
helm test my-oumi
```

## Uninstalling the Chart

To uninstall/delete the `my-oumi` deployment:

```bash
helm uninstall my-oumi
```