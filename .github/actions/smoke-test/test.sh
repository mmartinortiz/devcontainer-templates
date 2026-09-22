#!/bin/bash
TEMPLATE_ID="$1"
set -e

SRC_DIR="/tmp/${TEMPLATE_ID}"
echo "Running Smoke Test"

ID_LABEL="test-container=${TEMPLATE_ID}"
# shellcheck disable=SC2016 # single-quoted on purpose: expands inside the container, not here.
devcontainer exec --workspace-folder "${SRC_DIR}" --id-label "${ID_LABEL}" /bin/sh -c 'set -e && if [ -f "test-project/test.sh" ]; then cd test-project && if [ "$(id -u)" = "0" ]; then chmod +x test.sh; else sudo chmod +x test.sh; fi && ./test.sh; else ls -a; fi'

# Clean up
mapfile -t CONTAINER_IDS < <(docker container ls -f "label=${ID_LABEL}" -q)
docker rm -f "${CONTAINER_IDS[@]}"
rm -rf "${SRC_DIR}"
