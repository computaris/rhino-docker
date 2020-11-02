#!/bin/sh

BASEDIR=$(dirname "$0")
CONFIG_VARIABLES=$(cat ${BASEDIR}/config_variables.template)

eval "echo \"${CONFIG_VARIABLES}\"" > ${RHINO_HOME}/config/config_variables

