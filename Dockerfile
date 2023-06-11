# required for libssl and others
FROM ubuntu:22.04

# set the github runner version
ARG RUNNER_VERSION="2.304.0"
ARG USER=runner

# update the base packages and add a non-sudo user
RUN apt-get update -y && apt-get upgrade -y

# install python and the packages the your code depends on along with jq so we can parse JSON
# add additional packages as necessary
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl \
    build-essential \
    docker.io \
    git \
    jq \
    libssl-dev \
    libffi-dev \
    python3 \
    python3-venv \
    python3-dev \
    python3-pip

RUN useradd -m $USER && usermod -aG docker $USER

# cd into the user directory, download and unzip the github actions runner
RUN cd /home/$USER && mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# install some additional dependencies
RUN /home/$USER/actions-runner/bin/installdependencies.sh

# must execute action-runner as non-root
USER $USER
WORKDIR /home/$USER/
CMD /bin/bash

