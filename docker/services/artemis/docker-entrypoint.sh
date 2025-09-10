#!/bin/bash
set -e

# Use the same paths as the official docker-run.sh
BROKER_HOME=/var/lib/artemis-instance
CONFIG_PATH=$BROKER_HOME/etc
export BROKER_HOME CONFIG_PATH

if [[ ${ANONYMOUS_LOGIN,,} == "true" ]]; then
  LOGIN_OPTION="--allow-anonymous"
else
  LOGIN_OPTION="--require-login"
fi

# Create broker instance if it does not exist
if ! [ -f $BROKER_HOME/etc/broker.xml ]; then
    echo "Creating new Artemis broker instance..."
    CREATE_ARGUMENTS="--user ${ARTEMIS_USER} --password ${ARTEMIS_PASSWORD} --silent ${LOGIN_OPTION} ${EXTRA_ARGS}"
    /opt/activemq-artemis/bin/artemis create ${CREATE_ARGUMENTS} $BROKER_HOME
else
    echo "Using existing Artemis broker instance..."
fi

# Copy user overrides if any (this is your custom addition)
if [ -d $BROKER_HOME/etc-override ]; then
    echo "Copying configuration overrides..."
    for file in `ls $BROKER_HOME/etc-override`; do
        echo "Copying override file: $file"
        cp $BROKER_HOME/etc-override/$file $BROKER_HOME/etc/ 2>/dev/null || true
    done
fi

# Run the broker from the instance folder
echo "Starting Artemis broker..."
cd $BROKER_HOME
exec ./bin/artemis run
