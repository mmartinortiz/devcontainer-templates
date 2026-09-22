#!/bin/bash
# Determines which template ids (directories under src/) are affected by the
# changes between $1 (base ref/sha) and $2 (head ref/sha).
#
# A template id is considered affected if:
#   - a file under src/<id>/** or test/<id>/** changed, or
#   - a file under the shared test harness (.github/actions/smoke-test/** or
#     test/test-utils/**) changed, in which case ALL templates are affected.
#
# Outputs a JSON array of template ids on stdout, e.g. ["python","base"].
# Emits "[]" when nothing is affected.

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

declare -A AFFECTED=()

if [ "${HARNESS_CHANGED}" = "true" ]; then
    for id in "${ALL_TEMPLATE_IDS[@]}"; do
        AFFECTED["${id}"]=1
    done
else
    while IFS= read -r file; do
        [ -z "${file}" ] && continue
        for id in "${ALL_TEMPLATE_IDS[@]}"; do
            if [[ "${file}" == "src/${id}/"* ]] || [[ "${file}" == "test/${id}/"* ]]; then
                AFFECTED["${id}"]=1
            fi
        done
    done <<<"${CHANGED_FILES}"
fi

if [ "${#AFFECTED[@]}" -eq 0 ]; then
    echo "[]"
    exit 0
fi

jq -nc --args '$ARGS.positional' "${!AFFECTED[@]}"
