#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source $SCRIPT_DIR/../.env

kubectl create secret generic ${HELM_RELEASE}-gitlab-runner-token \
    --from-literal=runner-registration-token=$RUNNER_TOKEN \
    --from-literal=runner-token="" \