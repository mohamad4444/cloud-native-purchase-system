#!/usr/bin/env bash
# Check whether the ports this project needs are free, and report which process
# is using any port that is occupied.
#
# Usage:
#   ./scripts/check-ports.sh            # check all project ports
#   ./scripts/check-ports.sh 8080 4200  # check specific ports
#   ./scripts/check-ports.sh --help

set -uo pipefail

info()  { printf '\033[1;34m[%s]\033[0m %s\n' 'INFO' "$*"; }
ok()    { printf '\033[1;32m[ OK ]\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33m[WARN]\033[0m %s\n' "$*"; }
fail()  { printf '\033[1;31m[FAIL]\033[0m %s\n' "$*" >&2; exit 1; }

usage() {
    cat <<'EOF'
Usage: ./scripts/check-ports.sh [PORTS...]

Checks the ports used by this project and tells you which process owns each
occupied port. With no arguments, checks the full list below.

Ports:
  4200  frontend (port-forward)
  8088  Keycloak (port-forward; 8080 is avoided because other tools use it)
  8001  purchase API (port-forward)
  8002  inventory API (port-forward)
  5000  local registry (port-forward)
  8161  Artemis web console (port-forward)
  3000  Grafana (port-forward)
  3100  Loki (port-forward)
  5432  PostgreSQL (local development fallback)
  61616 Artemis broker (local development fallback)
  9000  Portainer dashboard
  8000  Yacht dashboard
  2201  Dockge dashboard

Exit code is 0 when all checked ports are free, 1 when any is occupied.
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    exit 0
fi

if [[ $# -gt 0 ]]; then
    PORTS=("$@")
else
    PORTS=(4200 8088 8001 8002 5000 8161 3000 3100 5432 61616 9000 8000 2201)
fi

DESCRIPTIVE=0
if [[ $# -eq 0 ]]; then DESCRIPTIVE=1; fi

describe() {
    case "$1" in
        4200) echo "frontend" ;;
        8088) echo "Keycloak" ;;
        8001) echo "purchase API" ;;
        8002) echo "inventory API" ;;
        5000) echo "local registry" ;;
        8161) echo "Artemis console" ;;
        3000) echo "Grafana" ;;
        3100) echo "Loki" ;;
        5432) echo "PostgreSQL" ;;
        61616) echo "Artemis broker" ;;
        9000) echo "Portainer" ;;
        8000) echo "Yacht" ;;
        2201) echo "Dockge" ;;
        *) echo "custom" ;;
    esac
}

# Try several tools so this works on a minimal system too.
port_owner() {
    local port="$1"
    local out=""

    if command -v ss >/dev/null 2>&1; then
        out="$(ss -ltnp 2>/dev/null | grep -E ":${port}([[:space:]]|$)" || true)"
    fi
    if [[ -z "$out" ]] && command -v lsof >/dev/null 2>&1; then
        out="$(lsof -nP -iTCP:"${port}" -sTCP:LISTEN 2>/dev/null || true)"
    fi
    if [[ -z "$out" ]] && command -v netstat >/dev/null 2>&1; then
        out="$(netstat -ltnp 2>/dev/null | grep -E ":${port}([[:space:]]|$)" || true)"
    fi

    printf '%s' "$out"
}

info "Checking project ports"
echo ""

OCCUPIED=0
for port in "${PORTS[@]}"; do
    label="$(describe "$port")"
    owner="$(port_owner "$port")"

    if [[ -n "$owner" ]]; then
        OCCUPIED=$((OCCUPIED + 1))
        if [[ "$DESCRIPTIVE" -eq 1 ]]; then
            printf '\033[1;33m[BUSY ]\033[0m %-6s %-18s\n' "$port" "$label"
        else
            printf '\033[1;33m[BUSY ]\033[0m %s\n' "$port"
        fi
        # Show the first matching line, trimmed
        printf '%s\n' "$owner" | head -3 | sed 's/^/         /'
        echo ""
    else
        if [[ "$DESCRIPTIVE" -eq 1 ]]; then
            ok "$(printf '%-6s %-18s free' "$port" "$label")"
        else
            ok "${port} free"
        fi
    fi
done

echo ""
if [[ "$OCCUPIED" -eq 0 ]]; then
    ok "All checked ports are free"
    exit 0
else
    warn "${OCCUPIED} port(s) occupied"
    echo ""
    info "Common remedies:"
    echo "  - Stop the owning process:      kill <PID>"
    echo "  - Stop a Docker container:      docker stop <NAME>"
    echo "  - Restart port-forwards:        bash portforwarding/port-forward.sh restart"
    echo "  - This project uses 8088 for Keycloak because 8080 is often taken."
    exit 1
fi
