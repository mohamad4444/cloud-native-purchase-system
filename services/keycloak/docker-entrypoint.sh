#!/bin/bash
set -e

# Import realms and start Keycloak in dev mode
/opt/keycloak/bin/kc.sh start-dev --import-realm
