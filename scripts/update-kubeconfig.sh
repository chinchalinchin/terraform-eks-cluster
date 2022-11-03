#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source $SCRIPT_DIR/../.env

aws eks update-kubeconfig \
  --region $AWS_DEFAULT_REGION \
  --name $EKS_CLUSTER_NAME