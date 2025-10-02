stern -n staging 'inventory-.*' --color never --output raw --only-log-lines
stern -n staging 'inventory-.*' --color never --output raw --only-log-lines   | while IFS= read -r line; do       echo "$line" | jq . >/dev/null 2>&1 || echo "INVALID JSON: $line";     done
kubectl rollout restart deployment -n staging
kubectl rollout restart deployment inventory -n staging
kubectl rollout restart deployment purchase -n staging

stern -n staging 'inventory-.*' --color never --output raw --only-log-lines \
  | while IFS= read -r line; do
      echo "$line" | jq . >/dev/null 2>&1 && echo "$line"
  done


  stern -n staging 'inventory-.*' --color never --output raw --only-log-lines \
  | grep -E '^\s*\{.*\}\s*$'

  stern -n staging 'inventory-.*' --color never --output raw --only-log-lines \
  | jq -c . 2>/dev/null
stern -n staging 'inventory-.*' --color never --output raw --only-log-lines \
  | while IFS= read -r line; do
      echo "$line" | jq . >/dev/null 2>&1 && echo "$line"
    done
stern -n staging 'inventory-.*' --color never --output raw --only-log-lines \
  | jq -r '[.timestamp, .level, .app, .thread, "\(.caller_class_name).\(.caller_method_name)(\(.caller_file_name):\(.caller_line_number)) - \(.message)"] | @tsv' \
  | awk -F'\t' '{printf "[%s] [%s] [%s] [%s] %s\n", $1,$2,$3,$4,$5}'


  stern -n staging 'inventory-.*' --color never --output raw --only-log-lines \
  | grep -E '^\s*\{.*\}\s*$' \
  | jq -r '[.timestamp, .level, .app, .thread, "\(.caller_class_name).\(.caller_method_name)(\(.caller_file_name):\(.caller_line_number)) - \(.message)"] | @tsv' \
  | awk -F'\t' '{printf "[%s] [%s] [%s] [%s] %s\n", $1,$2,$3,$4,$5}'
