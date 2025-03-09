#!/bin/bash
cd $(dirname "$0")
source test-utils.sh

# Template specific tests
check "distro" lsb_release -c
check "version" python -V | grep 3.13
check "uv autocomplete fish" [ -e /usr/share/fish/completions/uv.fish ]


# Report result
reportResults
