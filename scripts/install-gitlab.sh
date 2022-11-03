
#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source $SCRIPT_DIR/../.env

if [ ! -f "$SCRIPT_DIR/../helm/gitlab/values.yml" ]
then 
    cp $SCRIPT_DIR/../helm/gitlab/.sample.values.yml $SCRIPT_DIR/../helm/gitlab/values.yml
    echo "Configure ./helm/gitlab/values.yaml and then re-execute script"
fi

helm install ${HELM_RELEASE} \
    gitlab/gitlab -f \
        $SCRIPT_DIR/../helm/gitlab/values.yml