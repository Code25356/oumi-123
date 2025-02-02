package templates

import corev1 "k8s.io/api/core/v1"

#ConfigMap: corev1.#ConfigMap & {
	_config:    #Values
	_defaults:  _defaults
	apiVersion: "v1"
	kind:       "ConfigMap"
	metadata: {
		name:        "\(_config.metadata.name)-config"
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
	data: {
		// Python settings
		PYTHONUNBUFFERED:       "1"
		PYTHONDONTWRITEBYTECODE: "1"

		// Application settings
		OUMI_LOG_LEVEL:         _config.config.logLevel
		OUMI_DEVICE:           _config.config.device
		OUMI_NUM_WORKERS:      "\(_config.config.numWorkers)"
		OUMI_MODEL_CACHE_DIR:   _config.config.modelCache
		OUMI_DATASET_CACHE_DIR: _config.config.datasetCache
		OUMI_HOST:             _config.config.host
		OUMI_PORT:             "\(_config.config.port)"
	}
}