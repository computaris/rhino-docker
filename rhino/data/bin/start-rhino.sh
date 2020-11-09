#!/bin/sh

BASEDIR=$(dirname "$0")
RHINO_HOME=/opt/opencloud/rhino/node

KEYSTORE_GENERATION_OUTPUT=$(${BASEDIR}/../generate-keystores.sh)

if [ "$?" -eq 0 ]
then
    echo KEYSTORE_GENERATION_OUTPUT
fi

RHINO_CONSOLE_LOGGER=$RHINO_HOME/consolelog.sh
# Command used to start Rhino
RHINO_START_COMMAND="$RHINO_HOME/start-rhino.sh $RHINO_START_ARGUMENTS"

${RHINO_START_COMMAND} | ${RHINO_CONSOLE_LOGGER}
