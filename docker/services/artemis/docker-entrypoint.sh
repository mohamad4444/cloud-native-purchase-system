#!/bin/sh
set -e

ARTEMIS_HOME=/opt/activemq-artemis
ARTEMIS_INSTANCE=/var/lib/artemis-instance

if [ "${ANONYMOUS_LOGIN}" = "true" ]; then
  LOGIN_OPTION="--allow-anonymous"
else
  LOGIN_OPTION="--require-login"
fi

# Check if broker instance already exists - if broker.xml exists, instance is already set up
if [ ! -f "${ARTEMIS_INSTANCE}/etc/broker.xml" ]; then
  echo "Creating new Artemis instance at: ${ARTEMIS_INSTANCE}"
  ${ARTEMIS_HOME}/bin/artemis create \
    --user "${ARTEMIS_USER:-artemis}" \
    --password "${ARTEMIS_PASSWORD:-artemis}" \
    --silent \
    --force \
    ${LOGIN_OPTION} \
    ${EXTRA_ARGS:---http-host 0.0.0.0 --relax-jolokia} \
    "${ARTEMIS_INSTANCE}"

  # Copy user overrides if any
  if [ -d "${ARTEMIS_INSTANCE}/etc-override" ]; then
    echo "Applying configuration overrides..."
    cp -r "${ARTEMIS_INSTANCE}/etc-override/"* "${ARTEMIS_INSTANCE}/etc/" 2>/dev/null || true
  fi
else
  echo "Broker instance already exists at ${ARTEMIS_INSTANCE}, skipping creation."
fi

# Run the broker
exec "${ARTEMIS_INSTANCE}/bin/artemis" run
