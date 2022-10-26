#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source $SCRIPT_DIR/../.env

kubectl get ingress/${HELM_RELEASE}-webservice-default -ojsonpath='{.status.loadBalancer.ingress[0].hostname}'