#!/bin/bash
# Example about how to call semgrep using its single-linter megalinter docker image

# DEFINE SCRIPT VARIABLES (you can do the same in your script)
ROOT_FOLDER="C:/git" # Always put an absolute path here. Must be the root of all your repositories
LOCAL_SSH_FOLDER="C:/Users/33614/.ssh"
LOCAL_REPORTS_FOLDER="C:/Users/33614/.megaLinter-reports"
DOCKER_IMAGE="megalinter/megalinter-only-repository_trivy:v6-sarif-enhance"
LINTER_NAME="REPOSITORY_TRIVY"
WORKSPACE_TO_LINT="demo-megalinter-security-flavor" #name of the folder you want to lint within root folder

set -eu
# REMOVE PREVIOUS TEST CONTAINERS
echo "Removing previous tests containers..."
docker rm --force "$(docker ps --all --filter name=megalinter-ssh-REPOSITORY_TRIVY -q)" || true
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
       -v "$LOCAL_REPORTS_FOLDER:/tmp/report" \
       -v "$LOCAL_SSH_FOLDER:/root/docker_ssh" \
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
echo "- follow instructions :)"
