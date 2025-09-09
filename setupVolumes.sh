#!/usr/bin/env bash
set -euo pipefail

# Run from repo root (where ./docker exists)
BASE_DIR="$(pwd)"
VOLUMES_DIR="$BASE_DIR/docker/volumes"

# Volumes used in your compose (edit if you add/remove volumes)
volumes=(keycloak_db_data purchase_db_data inventory_db_data artemis-data grafana-data loki-data promtail-positions)

# Defaults
DEFAULT_OWNER="$(id -u):$(id -g)"   # current user numeric uid:gid
DEFAULT_MODE="0755"

# Per-volume owner override (use numeric uids/gids, e.g. "1001:1001")
# You told me artemis needs 1001:1001 — kept below.
declare -A OWNER_MAP=(
  ["keycloak_db_data"]="1000:1000"
  ["purchase_db_data"]="1000:1000"
  ["inventory_db_data"]="1000:1000"
  ["artemis-data"]="1000:1000"
  ["grafana-data"]="1000:1000"
  ["loki-data"]="1000:1000"
  ["promtail-positions"]="1000:1000"
)

# Per-volume mode override
declare -A MODE_MAP=(
  ["keycloak_db_data"]="0700"
  ["purchase_db_data"]="0700"
  ["inventory_db_data"]="0700"
  ["artemis-data"]="0777"
  ["grafana-data"]="0777"
  ["loki-data"]="0777"
  ["promtail-positions"]="0777"
)


echo "Resetting volumes in: $VOLUMES_DIR"
mkdir -p "$VOLUMES_DIR"

# -- remove everything inside volumes dir
echo "Removing existing folders under $VOLUMES_DIR ..."
rm -rf "$VOLUMES_DIR"/*

# Recreate and apply owners/modes
for v in "${volumes[@]}"; do
  target="$VOLUMES_DIR/$v"
  echo "Creating: $target"
  mkdir -p "$target"

  owner="${OWNER_MAP[$v]:-$DEFAULT_OWNER}"
  mode="${MODE_MAP[$v]:-$DEFAULT_MODE}"

  echo " -> chown $owner $target"
  sudo chown -R "$owner" "$target"

  echo " -> chmod $mode $target"
  sudo chmod -R "$mode" "$target"
done

echo "All done. Volumes recreated with specified owners/modes."
