#!/bin/bash
# Builds (unless an already-built tag is passed) and smoke-tests the images/base Dockerfile.
#
# Usage:
#   test/images/base/test.sh              # builds the image itself, then tests it
#   test/images/base/test.sh some:tag      # tests an already-built image, skips the build

set -euo pipefail

cd "$(dirname "$0")"
source ../../test-utils/test-utils.sh

IMAGE_CONTEXT="$(cd ../../../images/base && pwd)"
IMAGE_TAG="${1:-devcontainer-base-test}"
BUILT_HERE=false

if [ "$#" -eq 0 ]; then
    echo "(*) Building image from ${IMAGE_CONTEXT}"
    docker build -t "${IMAGE_TAG}" "${IMAGE_CONTEXT}"
    BUILT_HERE=true
fi

cleanup() {
    if [ "${BUILT_HERE}" = true ]; then
        docker rmi -f "${IMAGE_TAG}" >/dev/null 2>&1 || true
    fi
}
trap cleanup EXIT

run() {
    docker run --rm "${IMAGE_TAG}" "$@"
}

runFish() {
    docker run --rm "${IMAGE_TAG}" fish -c "$1"
}

export -f run runFish
export IMAGE_TAG

# Tool availability
check "uv is available" run uv --version
check "uvx is available" run uvx --version
check "starship is available" run starship --version
check "prek is available" run prek --version
check "vim is available" run vim --version
check "fish is available" run fish --version

# Default user / shell
check "default user is vscode" bash -c "[ \"\$(run whoami)\" = 'vscode' ]"
check "vscode's default shell is fish" bash -c "run bash -lc 'echo \$SHELL' | grep -q '/usr/bin/fish'"
check "~/.local/bin is on PATH" bash -c "runFish 'echo \$PATH' | grep -q '/home/vscode/.local/bin'"

# Fish completions
check "uv fish completions exist" run test -s /usr/share/fish/vendor_completions.d/uv.fish
check "prek fish completions exist" run test -s /usr/share/fish/vendor_completions.d/prek.fish

# Report result
reportResults
