# Example about how to call security flavor with bandit, using local repo .mega-linter.yml config,
# and force an unique linter to be run with ENABLE_LINTERS variable

ROOT_FOLDER=$PWD
# ROOT_FOLDER="c:/git/demo-megalinter-security-flavor" # If run on windows, replace $PWD by absolute path of the repository root
DOCKER_IMAGE="megalinter/megalinter-security:v6-alpha"
echo "Running MegaLinter on $ROOT_FOLDER using docker image $DOCKER_IMAGE"
docker run -v "$ROOT_FOLDER:/tmp/lint" -e ENABLE_LINTERS=PYTHON_BANDIT "$DOCKER_IMAGE" 

# SARIF file is then available 
OUTPUT_FILE="$ROOT_FOLDER/megalinter-reports/megalinter-report.sarif"
echo ""
echo "SARIF file is available at $OUTPUT_FILE"
