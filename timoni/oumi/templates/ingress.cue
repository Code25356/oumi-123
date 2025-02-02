package templates

import networkingv1 "k8s.io/api/networking/v1"

#Ingress: networkingv1.#Ingress & {
	_config:    #Values
	_defaults:  _defaults
	apiVersion: "networking.k8s.io/v1"
	kind:       "Ingress"
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
		if _config.ingress.annotations != _|_ {
			annotations: _config.ingress.annotations
		}
	}
	spec: networkingv1.#IngressSpec & {
		if _config.ingress.className != _|_ {
			ingressClassName: _config.ingress.className
		}
		rules: [ for host in _config.ingress.hosts {
			host: host.host
			http: paths: [ for path in host.paths {
				path:     path.path
				pathType: path.pathType
				backend: service: {
					name: _config.metadata.name
					port: name: "http"
				}
			}]
		}]
		if _config.ingress.tls != _|_ {
			tls: _config.ingress.tls
		}
	}
}