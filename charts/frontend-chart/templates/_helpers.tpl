{{- define "frontend-chart.name" -}}
frontend-chart
{{- end }}

{{- define "frontend-chart.fullname" -}}
{{ .Release.Name }}-{{ include "frontend-chart.name" . }}
{{- end }}

{{- define "frontend-chart.serviceAccountName" -}}
{{- default (include "frontend-chart.fullname" .) .Values.serviceAccount.name -}}
{{- end }}

{{- define "frontend-chart.labels" -}}
app.kubernetes.io/name: {{ include "frontend-chart.name" . }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "frontend-chart.configmap" -}}
{{- include "frontend-chart.fullname" . }}-config
{{- end -}}

