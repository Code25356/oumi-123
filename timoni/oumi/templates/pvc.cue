package templates

import corev1 "k8s.io/api/core/v1"

#PersistentVolumeClaim: corev1.#PersistentVolumeClaim & {
	_config:    #Values
	_defaults:  _defaults
	apiVersion: "v1"
	kind:       "PersistentVolumeClaim"
	metadata: {
		name:        "\(_config.metadata.name)-data"
		namespace:   _config.metadata.namespace
		labels:      _defaults._commonLabels
		annotations: _defaults._commonAnnotations
		if _config.metadata.annotations != _|_ {
			annotations: _config.metadata.annotations
		}
		if _config.metadata.labels != _|_ {
			labels: _config.metadata.labels
		}
		if _config.persistence.annotations != _|_ {
			annotations: _config.persistence.annotations
		}
	}
	spec: corev1.#PersistentVolumeClaimSpec & {
		accessModes: [_config.persistence.accessMode]
		resources: requests: storage: _config.persistence.size
		if _config.persistence.storageClass != _|_ {
			storageClassName: _config.persistence.storageClass
		}
	}
}