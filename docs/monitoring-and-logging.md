# Monitoring and Logging

## Grafana Loki Queries

**Simple query for standard logs:**

```log
{service="$service", stream="stdout"} |= "INFO"
```

**Query for JSON-formatted logs:**

```log
{service="$service", stream="stdout"}
| json
| level="INFO"
| app="purchase-system"
| line_format "{{.timestamp}} {{.level}} {{.app}} {{.message}}"
```
