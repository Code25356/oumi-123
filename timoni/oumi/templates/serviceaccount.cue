package templates

import corev1 "k8s.io/api/core/v1"

#ServiceAccount: corev1.#ServiceAccount & {
	_config:    #Values
	_defaults:  _defaults
	apiVersion: "v1"
	kind:       "ServiceAccount"
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
		if _config.serviceAccount.annotations != _|_ {
			annotations: _config.serviceAccount.annotations
		}
	}
}