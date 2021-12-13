# Example about how to call python bandit using its single-linter megalinter docker image
START_TIME=$(date +%s%N)

# DEFINE SCRIPT VARIABLES (you can do the same in your script)
ROOT_FOLDER="c:/git" # Always put an absolute path here
DOCKER_IMAGE="megalinter/megalinter-only-python_bandit:v6-alpha"
LINTER_NAME="PYTHON_BANDIT"

# REMOVE PREVIOUS TEST CONTAINERS
echo "Removing previous tests containers..."
docker rm --force $(docker ps --filter name=megalinter -q) || true
echo ""
# docker container prune --filter name=megalinter-sshd --force

# PULL LATEST MEGALINTER IMAGE VERSION
echo "Pulling latest docker image $DOCKER_IMAGE..."
docker pull "$DOCKER_IMAGE" 

# START MEGALINTER SERVER CONTAINER
# Internal flask server runs on port 80
# MEGALINTER_SERVER is important,  so entrypoint.sh just runs flask server
# Remove -d if you want to see that the server if well started
echo "Starting MegaLinter container with volume $ROOT_FOLDER, using docker image $DOCKER_IMAGE..."
docker run -p 1984:80 --name "megalinter-server-$LINTER_NAME" -v "$ROOT_FOLDER:/tmp/lint" -e MEGALINTER_SERVER="true" -d "$DOCKER_IMAGE"

# STATS
echo ""
ELAPSED=$((($(date +%s%N) - $START_TIME)/1000000))
echo "MegaLinter server docker image $DOCKER_IMAGE has started in $ELAPSED ms"

# DISPLAY MEGALINTER CONTAINER
echo ""
docker ps

