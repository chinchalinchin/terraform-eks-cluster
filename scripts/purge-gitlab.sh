
#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source $SCRIPT_DIR/../.env

helm uninstall ${HELM_RELEASE}

kubectl delete secret ${HELM_RELEASE}-acme-key
kubectl delete secret ${HELM_RELEASE}-certmanager-webhook-ca
kubectl delete secret ${HELM_RELEASE}-gitaly-secret
kubectl delete secret ${HELM_RELEASE}-gitlab-initial-root-password
kubectl delete secret ${HELM_RELEASE}-gitlab-kas-secret
kubectl delete secret ${HELM_RELEASE}-gitlab-runner-secret
kubectl delete secret ${HELM_RELEASE}-gitlab-shell-host-keys
kubectl delete secret ${HELM_RELEASE}-gitlab-shell-secret
kubectl delete secret ${HELM_RELEASE}-gitlab-tls
kubectl delete secret ${HELM_RELEASE}-gitlab-workhorse-secret
kubectl delete secret ${HELM_RELEASE}-kas-private-api
kubectl delete secret ${HELM_RELEASE}-minio-secret
kubectl delete secret ${HELM_RELEASE}-postgresql-password 
kubectl delete secret ${HELM_RELEASE}-rails-secret
kubectl delete secret ${HELM_RELEASE}-redis-secret
kubectl delete secret ${HELM_RELEASE}-registry-httpsecret
kubectl delete secret ${HELM_RELEASE}-registry-notification
kubectl delete secret ${HELM_RELEASE}-registry-secret
kubectl delete secret ${HELM_RELEASE}-registry-tls