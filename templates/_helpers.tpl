{{/*
Expand the name of the chart.
*/}}
{{- define "postgresql.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "postgresql.fullname" -}}
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
{{- define "postgresql.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "postgresql.labels" -}}
helm.sh/chart: {{ include "postgresql.chart" . }}
{{ include "postgresql.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "postgresql.selectorLabels" -}}
app.kubernetes.io/name: {{ include "postgresql.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Primary labels (with role selector)
*/}}
{{- define "postgresql.primary.selectorLabels" -}}
{{ include "postgresql.selectorLabels" . }}
app.kubernetes.io/component: primary
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "postgresql.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "postgresql.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the name of the secret containing PostgreSQL passwords
*/}}
{{- define "postgresql.secretName" -}}
{{- if .Values.auth.existingSecret }}
{{- .Values.auth.existingSecret }}
{{- else }}
{{- include "postgresql.fullname" . }}
{{- end }}
{{- end }}

{{/*
Return the key for the postgres admin password in the secret
*/}}
{{- define "postgresql.adminPasswordKey" -}}
{{- if .Values.auth.existingSecret -}}
{{- .Values.auth.secretKeys.adminPasswordKey -}}
{{- else -}}
postgres-password
{{- end -}}
{{- end }}

{{/*
Return the key for the custom user password in the secret
*/}}
{{- define "postgresql.userPasswordKey" -}}
{{- if .Values.auth.existingSecret -}}
{{- .Values.auth.secretKeys.userPasswordKey -}}
{{- else -}}
password
{{- end -}}
{{- end }}

{{/*
Return the name of the ConfigMap with PostgreSQL configuration
*/}}
{{- define "postgresql.configmapName" -}}
{{- if .Values.primary.existingConfigmap }}
{{- .Values.primary.existingConfigmap }}
{{- else }}
{{- printf "%s-configuration" (include "postgresql.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Return the name of the ConfigMap/Secret with initdb scripts
*/}}
{{- define "postgresql.initdbScriptsCM" -}}
{{- if .Values.primary.initdb.scriptsConfigMap }}
{{- .Values.primary.initdb.scriptsConfigMap }}
{{- else if .Values.primary.initdb.scripts }}
{{- printf "%s-init-scripts" (include "postgresql.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Return the PostgreSQL image
*/}}
{{- define "postgresql.image" -}}
{{- $registry := coalesce .Values.global.imageRegistry .Values.image.registry }}
{{- printf "%s/%s:%s" $registry .Values.image.repository .Values.image.tag }}
{{- end }}

{{/*
Return the volumePermissions image
*/}}
{{- define "postgresql.volumePermissions.image" -}}
{{- $registry := coalesce .Values.global.imageRegistry .Values.volumePermissions.image.registry }}
{{- printf "%s/%s:%s" $registry .Values.volumePermissions.image.repository .Values.volumePermissions.image.tag }}
{{- end }}

{{/*
Return the primary headless service name
*/}}
{{- define "postgresql.primary.svcHeadless" -}}
{{- printf "%s-hl" (include "postgresql.fullname" .) }}
{{- end }}

{{/*
Return the primary service name
*/}}
{{- define "postgresql.primary.svcName" -}}
{{- include "postgresql.fullname" . }}
{{- end }}

{{/*
Return the PVC name for primary
*/}}
{{- define "postgresql.primary.pvcName" -}}
{{- if .Values.primary.persistence.existingClaim }}
{{- .Values.primary.persistence.existingClaim }}
{{- else }}
{{- printf "data-%s-0" (include "postgresql.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Common annotations
*/}}
{{- define "postgresql.annotations" -}}
{{- with .Values.commonAnnotations }}
{{- toYaml . }}
{{- end }}
{{- end }}
