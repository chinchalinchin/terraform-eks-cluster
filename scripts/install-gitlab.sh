#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source $SCRIPT_DIR/../.env

helm install $HELM_RELEASE gitlab/gitlab \
    --set nginx-ingress.controller.service.annotations="service.beta.kubernetes.io/aws-load-balancer-ssl-cert: $CERTIFICATE_ARN" \
    --set certmanager.install=false \
    --set global.ingress.configureCertmanager=false \
    --set global.hosts.externalIP="$ELASTIC_IP" \
    --set postgresql.install="false" \
    --set global.psql.host="$RDS_HOST" \
    --set global.psql.password.secret="${HELM_RELEASE}-postgresql-password" \
    --set global.psql.password.key="postgres-password" \
    --set global.psql.port="$RDS_PORT" \
    --set global.psql.database="$RDS_DB" \
    --set global.psql.username="$RDS_USERNAME"