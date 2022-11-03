#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source $SCRIPT_DIR/../.env

kubectl create secret generic automation-library-jira-license \
    --from-literal=license-key="$JIRA_LICENSE"
