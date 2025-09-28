{{- /*
Generate Keycloak startup arguments as a YAML list
*/ -}}
{{- define "keycloak.startArgs" -}}
{{- if .Values.ingress.enabled }}
- start
- --http-port={{ .Values.auth.service.port }}
- --https-port=0
- --http-relative-path={{ .Values.auth.configs.httpRelativePath }}
- --proxy-headers={{ .Values.auth.configs.proxyHeaders }}
- --hostname-strict={{ .Values.auth.configs.hostnameStrict | toString | lower }}
- --import-realm
{{- else }}
- start-dev
- --http-relative-path={{ .Values.auth.configs.httpRelativePath }}
- --import-realm
{{- end }}
{{- end }}
