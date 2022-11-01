#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source $SCRIPT_DIR/../.env

# kubectl create secret generic ${HELM_RELEASE}-postgresql-password \
#     --from-literal=postgresql-password=$RDS_PASSWORD \
#     --from-literal=postgresql-postgres-password=$RDS_PASSWORD


kubectl create secret generic ${HELM_RELEASE}-postgresql-credentials \
    --from-literal=postgresql-password=$RDS_PASSWORD \
    --from-literal=postgresql-username=$RDS_USERNAME