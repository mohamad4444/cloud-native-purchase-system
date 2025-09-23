{{- define "lib-helpers.labels" -}}
app.kubernetes.io/name: {{ include "lib-helpers.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | default "0.1.0" }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.labels }}
{{ toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{- define "lib-helpers.name" -}}
{{ .Chart.Name }}
{{- end }}