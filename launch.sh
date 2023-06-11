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

REGISTRY_URL=ghcr.io/cracked-machine

# sync local registry with the "latest" image
docker pull ${REGISTRY_URL}/actions_runner:ubuntu2204

# - create a new container
# - run the config command to register the runner with the github repo 
# - start the runner.
docker run -v /var/run/docker.sock:/var/run/docker.sock --name ${NAME} -it -t ${REGISTRY_URL}/actions_runner:ubuntu2204 bash -c "./actions-runner/config.sh --url ${URL} --token ${TOKEN} && ./actions-runner/run.sh"



