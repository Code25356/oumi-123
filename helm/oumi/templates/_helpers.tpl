{{/*
Expand the name of the chart.
*/}}
{{- define "oumi.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "oumi.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "oumi.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "oumi.labels" -}}
helm.sh/chart: {{ include "oumi.chart" . }}
{{ include "oumi.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "oumi.selectorLabels" -}}
app.kubernetes.io/name: {{ include "oumi.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "oumi.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "oumi.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get the appropriate resources based on deployment size
*/}}
{{- define "oumi.resources" -}}
{{- if eq .Values.deploymentSize "small" -}}
{{- .Values.resources.small | toYaml }}
{{- else if eq .Values.deploymentSize "large" -}}
{{- .Values.resources.large | toYaml }}
{{- else if eq .Values.deploymentSize "gpu" -}}
{{- .Values.resources.gpu | toYaml }}
{{- else -}}
{{- .Values.resources.medium | toYaml }}
{{- end -}}
{{- end }}