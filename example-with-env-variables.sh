# Example about how to call security flavor with bandit and variables

ROOT_FOLDER=$PWD
# ROOT_FOLDER="c:/git/demo-megalinter-security-flavor" # If run on windows, replace $PWD by absolute path of the repository root
DOCKER_IMAGE="megalinter/megalinter-security:v6-alpha"
echo "Renaming .mega-linter.yml file so it is ignored by MegaLinter"
mv "$ROOT_FOLDER/.mega-linter.yml" "$ROOT_FOLDER/.mega-linter.ignored"

echo "Running MegaLinter on $ROOT_FOLDER using docker image $DOCKER_IMAGE"
docker run -v "$ROOT_FOLDER:/tmp/lint" \
    -e ENABLE_LINTERS=PYTHON_BANDIT \
    -e APPLY_FIXES=none \
    -e DEFAULT_BRANCH=main \
    -e SHOW_ELAPSED_TIME=true \
    -e PRINT_ALPACA=false \
    -e FLAVOR_SUGGESTIONS=false \
    -e TEXT_REPORTER=false \
    -e SARIF_REPORTER=true \
    -e UPDATED_SOURCES_REPORTER=false \
    -e GITHUB_STATUS_REPORTER=false \
    -e GITHUB_COMMENT_REPORTER=false \
    "$DOCKER_IMAGE"

# SARIF file is then available 
OUTPUT_FILE="$ROOT_FOLDER/megalinter-reports/megalinter-report.sarif"
echo ""
echo "SARIF file is available at $OUTPUT_FILE"

echo "Renaming back .mega-linter.yml file"
mv "$ROOT_FOLDER/.mega-linter.ignored" "$ROOT_FOLDER/.mega-linter.yml"
