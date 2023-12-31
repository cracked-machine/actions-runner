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

# cleanup previous runner using this name
docker stop ${NAME}
docker rm ${NAME}

# - create a new container
# - volume mount the docker daemon (allows docker cli from within container)
# - volume mount current directory ($PWD)
# - run the config command to register the runner with the github repo, using mounted volume $PWD as the working directory.
# - start the runner.
docker run \
    -v /var/run/docker.sock:/var/run/docker.sock \ 
    -v ${PWD}:${PWD} \
    --name ${NAME} \
    -it \
    -t ${REGISTRY_URL}/actions_runner:ubuntu2204 \
    bash -c "./actions-runner/config.sh --url ${URL} --token ${TOKEN} --work ${PWD} && ./actions-runner/run.sh"



