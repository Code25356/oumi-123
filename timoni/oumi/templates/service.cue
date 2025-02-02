package templates

import corev1 "k8s.io/api/core/v1"

#Service: corev1.#Service & {
	_config:    #Values
	_defaults:  _defaults
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		name:        _config.metadata.name
		namespace:   _config.metadata.namespace
		labels:      _defaults._commonLabels
		annotations: _defaults._commonAnnotations
		if _config.metadata.annotations != _|_ {
			annotations: _config.metadata.annotations
		}
		if _config.metadata.labels != _|_ {
			labels: _config.metadata.labels
		}
	}
	spec: corev1.#ServiceSpec & {
		type: _config.service.type
		ports: [{
			port:       _config.service.port
			targetPort: "http"
			protocol:   "TCP"
			name:       "http"
			if _config.service.nodePort != _|_ {
				nodePort: _config.service.nodePort
			}
		}]
		selector: _defaults._commonLabels
	}
}