package templates

testStandard: {
	config: #Values & {
		metadata: {
			name:      "oumi-test"
			namespace: "default"
		}
	}

	objects: {
		sa:     _
		cm:     _
		pvc:    _
		deploy: _
		svc:    _
	}
}

testGPU: {
	config: #Values & {
		metadata: {
			name:      "oumi-gpu"
			namespace: "default"
		}
		resources: size: "gpu"
		config: device: "cuda"
	}

	objects: {
		sa:     _
		cm:     _
		pvc:    _
		deploy: _
		svc:    _
	}
}

testSmall: {
	config: #Values & {
		metadata: {
			name:      "oumi-small"
			namespace: "default"
		}
		resources: size: "small"
		persistence: enabled: false
	}

	objects: {
		sa:     _
		cm:     _
		deploy: _
		svc:    _
	}
}

testIngress: {
	config: #Values & {
		metadata: {
			name:      "oumi-ingress"
			namespace: "default"
		}
		ingress: {
			enabled: true
			hosts: [{
				host: "oumi.example.com"
				paths: [{
					path:     "/"
					pathType: "Prefix"
				}]
			}]
		}
	}

	objects: {
		sa:     _
		cm:     _
		pvc:    _
		deploy: _
		svc:    _
		ing:    _
	}
}