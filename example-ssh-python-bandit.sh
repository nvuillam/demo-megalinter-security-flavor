#!/bin/bash
# Example about how to call python bandit using its single-linter megalinter docker image

# DEFINE SCRIPT VARIABLES (you can do the same in your script)
ROOT_FOLDER="D:/git" # Always put an absolute path here. Must be the root of all your repositories
DOCKER_IMAGE="megalinter/megalinter-only-python_bandit:v6-alpha"
LINTER_NAME="PYTHON_BANDIT"
WORKSPACE_TO_LINT="demo-megalinter-security-flavor" #name of the folder you want to lint within root folder

# REMOVE PREVIOUS TEST CONTAINERS
echo "Removing previous tests containers..."
docker rm --force "$(docker ps --filter name=megalinter-ssh-PYTHON_BANDIT -q)" || true
echo ""
# docker container prune --filter name=megalinter-sshd --force

# PULL LATEST MEGALINTER IMAGE VERSION
echo "Pulling latest docker image $DOCKER_IMAGE..."
docker pull "$DOCKER_IMAGE" 

# START MEGALINTER SERVER CONTAINER
# Internal flask server runs on port 80
# MEGALINTER_SERVER is important,  so entrypoint.sh just runs flask server
# Remove -d if you want to see that the server if well started
START_TIME=$(date +%s%N)
echo "Starting MegaLinter container with volume $ROOT_FOLDER, using docker image $DOCKER_IMAGE..."
docker run \
       -p 1984:22 \
       --name "megalinter-ssh-$LINTER_NAME" \
       -v "$ROOT_FOLDER:/tmp/lint" \
       -e MEGALINTER_SSH="true" \
       -d \
       "$DOCKER_IMAGE"

# STATS
echo ""
ELAPSED=$((($(date +%s%N) - $START_TIME)/1000000))
echo "MegaLinter ssh docker image $DOCKER_IMAGE has started in $ELAPSED ms"

# DISPLAY MEGALINTER CONTAINER
echo ""
docker ps
echo ""

echo "- Connect via ssh: ssh root@localhost -p 1984"
echo "- input password 'root'"
echo "- run tmux"
echo "- run printenv: Dockerfile env variables are visible"
echo "- run DEFAULT_WORKSPACE=/tmp/lint/${WORKSPACE_TO_LINT} python -m megalinter.run"
