#!/bin/sh
set -e

# Create broker instance if it does not exist
if [ ! -f "/var/lib/artemis-instance/etc/broker.xml" ]; then
  /opt/apache-artemis/bin/artemis create \
    --user "${ARTEMIS_USER}" \
    --password "${ARTEMIS_PASSWORD}" \
    --silent \
    $( [ "${ANONYMOUS_LOGIN}" = "true" ] && echo "--allow-anonymous" || echo "--require-login") \
    ${EXTRA_ARGS} \
    /var/lib/artemis-instance
fi

# Copy user overrides if any
if [ -d "/var/lib/artemis-instance/etc-override" ]; then
  cp -r /var/lib/artemis-instance/etc-override/* /var/lib/artemis-instance/etc/ 2>/dev/null || true
fi

# Run the broker from the instance folder
exec /var/lib/artemis-instance/bin/artemis run
