package templates

// Template defines the Oumi module resources.
#Template: {
	config: #Values

	objects: {
		if config.serviceAccount.create {
			sa: #ServiceAccount & {
				_config:   config
				_defaults: _defaults
			}
		}

		cm: #ConfigMap & {
			_config:   config
			_defaults: _defaults
		}

		if config.persistence.enabled {
			pvc: #PersistentVolumeClaim & {
				_config:   config
				_defaults: _defaults
			}
		}

		deploy: #Deployment & {
			_config:   config
			_defaults: _defaults
		}

		svc: #Service & {
			_config:   config
			_defaults: _defaults
		}

		if config.ingress.enabled {
			ing: #Ingress & {
				_config:   config
				_defaults: _defaults
			}
		}
	}
}