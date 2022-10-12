#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source $SCRIPT_DIR/../.env

helm install gitlab/gitlab \
    --set nginx-ingress.controller.service.annotations="service.beta.kubernetes.io/aws-load-balancer-ssl-cert: $CERTIFICATE_ARN" \
    --set global.hosts.externalIP=$ELASTIC_IP