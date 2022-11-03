#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source $SCRIPT_DIR/../.env

K8S_DIR=$SCRIPT_DIR/../k8s

# TODO: parameterize into environment variables somehow...
AZ_1="b"
AZ_2="c"

kubectl create \
    -f ${K8S_DIR}/persistent-volume-az-${AZ_1}.yml

kubectl create \
    -f ${K8S_DIR}/persistent-volume-az-${AZ_2}.yml

