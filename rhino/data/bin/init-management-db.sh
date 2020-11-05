#!/bin/sh

BASEDIR=$(dirname "$0")
${BASEDIR}/configure.sh

${RHINO_HOME}/init-management-db.sh "$@"