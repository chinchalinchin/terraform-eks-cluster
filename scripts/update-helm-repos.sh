
#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source $SCRIPT_DIR/../.env

export ATLASSIAN_REPO="https://atlassian.github.io/data-center-helm-charts"
export GITLAB_REPO="https://charts.gitlab.io/"

helm repo add gitlab \
    $GITLAB_REPO

helm repo add atlassian-data-center \
    $ATLASSIAN_REPO

helm repo update