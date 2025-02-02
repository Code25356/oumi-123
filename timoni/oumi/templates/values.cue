package templates

// Values defines the configurable parameters for the Oumi module.
#Values: {
	// Kubernetes metadata
	metadata: {
		name:        string & =~"^[a-z0-9][a-z0-9-]*[a-z0-9]$" @tag(name)
		namespace:   string & =~"^[a-z0-9][a-z0-9-]*[a-z0-9]$" @tag(namespace)
		labels?: [string]:     string
		annotations?: [string]: string
	}

	// Deployment configuration
	deployment: {
		replicas: int & >0 | *1
		strategy: {
			type: *"RollingUpdate" | "Recreate"
			rollingUpdate?: {
				maxSurge:       *"25%" | int | string
				maxUnavailable: *"25%" | int | string
			}
		}
	}

	// Container image
	image: {
		repository: string | *"oumi"
		tag:        string | *"latest"
		pullPolicy: *"IfNotPresent" | "Always" | "Never"
	}

	// Resource requirements
	resources: {
		// Deployment size presets
		size: *"standard" | "small" | "large" | "gpu"

		// Override defaults with custom values
		requests?: {
			cpu?:    string
			memory?: string
			"nvidia.com/gpu"?: int
		}
		limits?: {
			cpu?:    string
			memory?: string
			"nvidia.com/gpu"?: int
		}
	}

	// Service configuration
	service: {
		type:     *"ClusterIP" | "NodePort" | "LoadBalancer"
		port:     int & >0 & <65536 | *8000
		nodePort?: int & >=30000 & <=32767
	}

	// Ingress configuration
	ingress: {
		enabled: bool | *false
		className?: string
		annotations?: [string]: string
		hosts: [...{
			host: string
			paths: [...{
				path:     string
				pathType: *"Prefix" | "Exact" | "ImplementationSpecific"
			}]
		}]
		tls?: [...{
			secretName?: string
			hosts: [...string]
		}]
	}

	// Persistence configuration
	persistence: {
		enabled:          bool | *true
		storageClass?:    string
		accessMode:       *"ReadWriteOnce" | "ReadWriteMany" | "ReadOnlyMany"
		size:            string | *"100Gi"
		annotations?: [string]: string
	}

	// Application configuration
	config: {
		logLevel:    *"INFO" | "DEBUG" | "WARNING" | "ERROR"
		device:      *"auto" | "cpu" | "cuda"
		numWorkers:  int | *2
		modelCache:  string | *"/data/models"
		datasetCache: string | *"/data/datasets"
		host:        string | *"0.0.0.0"
		port:        int | *8000
	}

	// Security settings
	security: {
		runAsUser:  int | *1000
		runAsGroup: int | *1000
		fsGroup:    int | *1000
	}

	// Service account configuration
	serviceAccount: {
		create:           bool | *true
		name?:           string
		annotations?: [string]: string
	}

	// Health check configuration
	probes: {
		liveness: {
			initialDelaySeconds: int | *60
			periodSeconds:      int | *10
			timeoutSeconds:     int | *5
			failureThreshold:   int | *6
		}
		readiness: {
			initialDelaySeconds: int | *30
			periodSeconds:      int | *10
			timeoutSeconds:     int | *5
			failureThreshold:   int | *6
		}
		startup: {
			initialDelaySeconds: int | *60
			periodSeconds:      int | *10
			timeoutSeconds:     int | *5
			failureThreshold:   int | *12
		}
	}
}