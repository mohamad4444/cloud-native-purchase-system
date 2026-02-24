# Makefile – Purchase System Cloud Native

.PHONY: default build-and-push deploy release \
        stern-inventory stern-inventory-json-validate \
        stern-inventory-json-only stern-inventory-jq-compact \
        stern-inventory-pretty stern-inventory-pretty-filtered \
        rollout-restart rollout-restart-inventory rollout-restart-purchase

# ─────────────────────────────────────────────
# Default target
# ─────────────────────────────────────────────
default: release

# ─────────────────────────────────────────────
# Build & Deploy
# ─────────────────────────────────────────────

## Build and push Docker images using Buildx
build-and-push:
	@echo "Building and pushing Docker images..."
	docker buildx bake base-images --push
	docker buildx bake application-images --push

## Deploy Helm charts using Helmfile
deploy:
	@echo "Deploying Helm charts with Helmfile..."
	helmfile --file ./environments -e staging sync

## Build images and deploy in one go
release: build-and-push deploy

# ─────────────────────────────────────────────
# Kubernetes – Rollout Restart
# ─────────────────────────────────────────────

## Restart all deployments in staging
rollout-restart:
	kubectl rollout restart deployment -n staging

## Restart only the inventory deployment
rollout-restart-inventory:
	kubectl rollout restart deployment inventory -n staging

## Restart only the purchase deployment
rollout-restart-purchase:
	kubectl rollout restart deployment purchase -n staging

# ─────────────────────────────────────────────
# Stern – Log Tailing (staging / inventory)
# ─────────────────────────────────────────────

## Tail raw inventory logs (no color, no metadata)
stern-inventory:
	stern -n staging 'inventory-.*' --color never --output raw --only-log-lines

## Tail inventory logs – validate each line is valid JSON (print warning otherwise)
stern-inventory-json-validate:
	stern -n staging 'inventory-.*' --color never --output raw --only-log-lines \
	  | while IFS= read -r line; do \
	      echo "$$line" | jq . >/dev/null 2>&1 || echo "INVALID JSON: $$line"; \
	    done

## Tail inventory logs – print only valid JSON lines (silent drop of non-JSON)
stern-inventory-json-only:
	stern -n staging 'inventory-.*' --color never --output raw --only-log-lines \
	  | grep -E '^\s*\{.*\}\s*$$'

## Tail inventory logs – compact JSON output via jq (skip invalid lines)
stern-inventory-jq-compact:
	stern -n staging 'inventory-.*' --color never --output raw --only-log-lines \
	  | jq -c . 2>/dev/null

## Tail inventory logs – pretty-printed structured format: [timestamp] [level] [app] [thread] message
stern-inventory-pretty:
	stern -n staging 'inventory-.*' --color never --output raw --only-log-lines \
	  | jq -r '[.timestamp, .level, .app, .thread, "\(.caller_class_name).\(.caller_method_name)(\(.caller_file_name):\(.caller_line_number)) - \(.message)"] | @tsv' \
	  | awk -F'\t' '{printf "[%s] [%s] [%s] [%s] %s\n", $$1,$$2,$$3,$$4,$$5}'

## Tail inventory logs – filter valid JSON first, then pretty-print structured format
stern-inventory-pretty-filtered:
	stern -n staging 'inventory-.*' --color never --output raw --only-log-lines \
	  | grep -E '^\s*\{.*\}\s*$$' \
	  | jq -r '[.timestamp, .level, .app, .thread, "\(.caller_class_name).\(.caller_method_name)(\(.caller_file_name):\(.caller_line_number)) - \(.message)"] | @tsv' \
	  | awk -F'\t' '{printf "[%s] [%s] [%s] [%s] %s\n", $$1,$$2,$$3,$$4,$$5}'
