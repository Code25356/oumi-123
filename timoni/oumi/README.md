# Oumi Timoni Module

This Timoni module deploys Oumi, a machine learning model serving platform, on Kubernetes.

## Features

- Supports both CPU and GPU deployments
- Configurable resource requirements with predefined sizes
- Optional persistent storage
- Optional ingress configuration
- Service account creation
- Configurable probes and security settings
- Common annotations and labels support

## Installation

To install this module with Timoni:

```bash
timoni -n default apply oumi oci://registry/oumi-module:0.1.0 \
  --values values.cue
```

## Configuration

### Basic Configuration

```cue
metadata: {
    name: "oumi"
    namespace: "default"
}

// Use standard CPU deployment
resources: {
    size: "standard"  // Options: "small", "standard", "large", "gpu"
}
```

### GPU Configuration

```cue
resources: {
    size: "gpu"  // Enables GPU support
}

config: {
    device: "cuda"  // Use CUDA for GPU acceleration
}
```

### Persistence Configuration

```cue
persistence: {
    enabled: true
    size: "100Gi"
    storageClass: "standard"  // Optional: specify storage class
}
```

### Ingress Configuration

```cue
ingress: {
    enabled: true
    hosts: [{
        host: "oumi.example.com"
        paths: [{
            path: "/"
            pathType: "Prefix"
        }]
    }]
}
```

## Testing

The module includes several test configurations in `tests/test_values.cue`:

- Standard CPU deployment
- GPU deployment
- Small deployment without persistence
- Deployment with ingress

To run tests:

```bash
timoni mod test ./timoni/oumi
```

## Values Reference

See `templates/values.cue` for the complete configuration reference.

## License

Apache-2.0