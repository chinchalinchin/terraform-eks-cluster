#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source $SCRIPT_DIR/../.env

K8S_DIR=$SCRIPT_DIR/../k8s

aws ec2 create-volume \
    --availability-zone=${AWS_DEFAULT_REGION}b \
    --size=10 \
    --volume-type=gp2

aws ec2 create-volume \
    --availability-zone=${AWS_DEFAULT_REGION}c \
    --size=10 \
    --volume-type=gp2


kubectl create \
    -f ${K8S_DIR}/persistent-volume-azb.yml

kubectl create \
    -f ${K8S_DIR}/persisetnt-volume-azc.yml

