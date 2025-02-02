package templates

import (
	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
)

#Deployment: appsv1.#Deployment & {
	_config:    #Values
	_defaults:  _defaults
	apiVersion: "apps/v1"
	kind:       "Deployment"
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
	spec: appsv1.#DeploymentSpec & {
		replicas: _config.deployment.replicas
		strategy: {
			type: _config.deployment.strategy.type
			if _config.deployment.strategy.type == "RollingUpdate" {
				rollingUpdate: _config.deployment.strategy.rollingUpdate
			}
		}
		selector: matchLabels: _defaults._commonLabels
		template: {
			metadata: {
				labels:      _defaults._commonLabels
				annotations: _defaults._commonAnnotations
			}
			spec: corev1.#PodSpec & {
				serviceAccountName: _config.serviceAccount.name
				securityContext: {
					runAsUser:  _config.security.runAsUser
					runAsGroup: _config.security.runAsGroup
					fsGroup:    _config.security.fsGroup
				}
				containers: [{
					name:            _config.metadata.name
					image:           "\(_config.image.repository):\(_config.image.tag)"
					imagePullPolicy: _config.image.pullPolicy
					ports: [{
						name:          "http"
						containerPort: _config.service.port
						protocol:      "TCP"
					}]
					envFrom: [{
						configMapRef: name: "\(_config.metadata.name)-config"
					}]
					resources: {
						if _config.resources.requests != _|_ {
							requests: _config.resources.requests
						}
						if _config.resources.requests == _|_ {
							requests: _defaults._resourceSizes[_config.resources.size].requests
						}
						if _config.resources.limits != _|_ {
							limits: _config.resources.limits
						}
						if _config.resources.limits == _|_ {
							limits: _defaults._resourceSizes[_config.resources.size].limits
						}
					}
					if _config.persistence.enabled {
						volumeMounts: [{
							name:      "data"
							mountPath: "/data"
						}]
					}
					livenessProbe: {
						httpGet: {
							path: "/health"
							port: "http"
						}
						initialDelaySeconds: _config.probes.liveness.initialDelaySeconds
						periodSeconds:       _config.probes.liveness.periodSeconds
						timeoutSeconds:      _config.probes.liveness.timeoutSeconds
						failureThreshold:    _config.probes.liveness.failureThreshold
					}
					readinessProbe: {
						httpGet: {
							path: "/health"
							port: "http"
						}
						initialDelaySeconds: _config.probes.readiness.initialDelaySeconds
						periodSeconds:       _config.probes.readiness.periodSeconds
						timeoutSeconds:      _config.probes.readiness.timeoutSeconds
						failureThreshold:    _config.probes.readiness.failureThreshold
					}
					startupProbe: {
						httpGet: {
							path: "/health"
							port: "http"
						}
						initialDelaySeconds: _config.probes.startup.initialDelaySeconds
						periodSeconds:       _config.probes.startup.periodSeconds
						timeoutSeconds:      _config.probes.startup.timeoutSeconds
						failureThreshold:    _config.probes.startup.failureThreshold
					}
				}]
				if _config.persistence.enabled {
					volumes: [{
						name: "data"
						persistentVolumeClaim: claimName: "\(_config.metadata.name)-data"
					}]
				}
			}
		}
	}
}