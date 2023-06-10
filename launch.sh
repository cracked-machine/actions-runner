#!/bin/bash

NAME=${1}
URL=${2}
TOKEN=${3}

usage() {
        echo "Usage: launch <container-name> <repo-url> <token>"
}

if [ -z ${NAME} ]; then
        usage
        exit 1
fi

if [ -z ${URL} ]; then
        usage
        exit 2
fi

if [ -z ${TOKEN} ]; then
        usage
        exit 3
fi

docker run --name ${NAME} -it -t ghcr.io/cracked-machine/actions_runner:ubuntu2204 bash -c "./actions-runner/config.sh --url ${URL} --token ${TOKEN} && ./actions-runner/run.sh"



