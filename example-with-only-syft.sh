#!/bin/bash
# Example about how to call single-linter megalinter docker image
START_TIME=$(date +%s%N)

# DEFINE SCRIPT VARIABLES (you can do the same in your script)
# ROOT_FOLDER=$PWD
ROOT_FOLDER="c:/git/demo-megalinter-security-flavor" # If run on windows, replace $PWD by absolute path of the repository root
DOCKER_IMAGE="megalinter/megalinter-only-repository_syft:v6-alpha"
DATE_TIME=$(date '+%Y%m%d%H%M')
SARIF_REPORTER_FILE_NAME="megalinter-report-$DATE_TIME.sarif"

# CALL MEGALINTER
echo "Running MegaLinter on $ROOT_FOLDER using docker image $DOCKER_IMAGE"
docker pull "$DOCKER_IMAGE"
docker run --rm -v "$ROOT_FOLDER:/tmp/lint" -e SARIF_REPORTER_FILE_NAME="$SARIF_REPORTER_FILE_NAME" -e LOG_LEVEL=DEBUG "$DOCKER_IMAGE" 

# SCRIPT EXECUTION RESULTS 
OUTPUT_FILE="$ROOT_FOLDER/megalinter-reports/$SARIF_REPORTER_FILE_NAME"
echo ""
echo "SARIF file is available at $OUTPUT_FILE"

ELAPSED=$((($(date +%s%N) - $START_TIME)/1000000))
echo "MegaLinter docker image $DOCKER_IMAGE has run in $ELAPSED ms"