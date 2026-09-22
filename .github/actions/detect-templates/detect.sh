#!/bin/bash
# Determines which template ids (directories under src/) are affected by the
# changes between $1 (base ref/sha) and $2 (head ref/sha).
#
# Prints two JSON arrays, one per line:
#   1. "smoke_test" set  - templates whose devcontainer build should be tested.
#                          Includes ALL templates if the shared test harness
#                          (.github/actions/smoke-test/** or test/test-utils/**)
#                          changed, since that affects every template's test run.
#   2. "changed" set     - templates whose own files (src/<id>/** or
#                          test/<id>/**) actually changed. This is the set that
#                          must have a bumped `version`; a harness-only change
#                          does not require any template to bump its version.
#
# Each line is a JSON array of template ids, e.g. ["python","base"], or "[]".

set -euo pipefail

BASE_REF="$1"
HEAD_REF="$2"

ALL_TEMPLATE_IDS=()
for dir in src/*/; do
    ALL_TEMPLATE_IDS+=("$(basename "${dir}")")
done

CHANGED_FILES="$(git diff --name-only "${BASE_REF}...${HEAD_REF}")"

HARNESS_CHANGED=false
if grep -qE '^(\.github/actions/smoke-test/|test/test-utils/)' <<<"${CHANGED_FILES}"; then
    HARNESS_CHANGED=true
fi

declare -A DIRECTLY_CHANGED=()
while IFS= read -r file; do
    [ -z "${file}" ] && continue
    for id in "${ALL_TEMPLATE_IDS[@]}"; do
        if [[ "${file}" == "src/${id}/"* ]] || [[ "${file}" == "test/${id}/"* ]]; then
            DIRECTLY_CHANGED["${id}"]=1
        fi
    done
done <<<"${CHANGED_FILES}"

to_json_array() {
    if [ "$#" -eq 0 ]; then
        echo "[]"
    else
        jq -nc --args '$ARGS.positional' "$@"
    fi
}

if [ "${HARNESS_CHANGED}" = "true" ]; then
    to_json_array "${ALL_TEMPLATE_IDS[@]}"
else
    to_json_array "${!DIRECTLY_CHANGED[@]}"
fi

to_json_array "${!DIRECTLY_CHANGED[@]}"
