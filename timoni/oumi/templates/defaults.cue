package templates

// Default values for the Oumi module
_defaults: {
	// Resource requirements based on size
	_resourceSizes: {
		small: {
			requests: {
				cpu:    "1"
				memory: "4Gi"
			}
			limits: {
				cpu:    "2"
				memory: "8Gi"
			}
		}
		standard: {
			requests: {
				cpu:    "2"
				memory: "8Gi"
			}
			limits: {
				cpu:    "4"
				memory: "16Gi"
			}
		}
		large: {
			requests: {
				cpu:    "4"
				memory: "16Gi"
			}
			limits: {
				cpu:    "8"
				memory: "32Gi"
			}
		}
		gpu: {
			requests: {
				cpu:              "2"
				memory:           "8Gi"
				"nvidia.com/gpu": 1
			}
			limits: {
				cpu:              "4"
				memory:           "16Gi"
				"nvidia.com/gpu": 1
			}
		}
	}

	// Common labels
	_commonLabels: {
		"app.kubernetes.io/name":       "oumi"
		"app.kubernetes.io/instance":   "\(metadata.name)"
		"app.kubernetes.io/version":    "\(image.tag)"
		"app.kubernetes.io/component":  "ml-serving"
		"app.kubernetes.io/part-of":    "oumi"
		"app.kubernetes.io/managed-by": "timoni"
	}

	// Common annotations
	_commonAnnotations: {
		"oumi.ai/gpu-enabled": "\(resources.size == "gpu")"
	}
}