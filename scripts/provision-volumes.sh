#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source $SCRIPT_DIR/../.env

# TODO: parameterize into environment variables somehow...
AZ_1="b"
AZ_2="c"

aws ec2 create-volume \
    --availability-zone=${AWS_DEFAULT_REGION}${AZ_1} \
    --size=10 \
    --volume-type=gp2

aws ec2 create-volume \
    --availability-zone=${AWS_DEFAULT_REGION}${AZ_2} \
    --size=10 \
    --volume-type=gp2

