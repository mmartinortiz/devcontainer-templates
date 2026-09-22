#!/bin/bash
# Validates a single devcontainer template directory (src/<id>/) and checks
# that its `version` has been bumped relative to the given base ref.
#
# Usage: validate-template.sh <template_id> <base_ref>
#
# <base_ref> is the git ref/sha to diff the version against (typically the
# PR base). If the template doesn't exist at <base_ref>, it's treated as new
# and the version-bump check is skipped.

set -euo pipefail

TEMPLATE_ID="$1"
BASE_REF="$2"
TEMPLATE_DIR="src/${TEMPLATE_ID}"
MANIFEST="${TEMPLATE_DIR}/devcontainer-template.json"

fail() {
    echo "::error::${1}"
    exit 1
}

[ -f "${MANIFEST}" ] || fail "Missing ${MANIFEST}"

jq empty "${MANIFEST}" || fail "${MANIFEST} is not valid JSON"

MANIFEST_ID="$(jq -r '.id // empty' "${MANIFEST}")"
[ "${MANIFEST_ID}" = "${TEMPLATE_ID}" ] || fail "'id' in ${MANIFEST} is '${MANIFEST_ID}', expected '${TEMPLATE_ID}'"

for field in name description version; do
    value="$(jq -r ".${field} // empty" "${MANIFEST}")"
    [ -n "${value}" ] || fail "'${field}' is missing or empty in ${MANIFEST}"
done

VERSION="$(jq -r '.version' "${MANIFEST}")"
echo "${VERSION}" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$' || fail "'version' ('${VERSION}') in ${MANIFEST} is not valid semver (X.Y.Z)"

# Every option must declare a non-null default.
OPTION_KEYS="$(jq -r '.options // {} | keys[]' "${MANIFEST}")"
while IFS= read -r option; do
    [ -z "${option}" ] && continue
    default="$(jq -r ".options.\"${option}\".default // empty" "${MANIFEST}")"
    [ -n "${default}" ] || fail "Option '${option}' in ${MANIFEST} has no 'default'"
done <<<"${OPTION_KEYS}"

# Every optionalPaths entry must exist on disk.
OPTIONAL_PATHS="$(jq -r '.optionalPaths // [] | .[]' "${MANIFEST}")"
while IFS= read -r optional_path; do
    [ -z "${optional_path}" ] && continue
    [ -e "${TEMPLATE_DIR}/${optional_path}" ] || fail "optionalPaths entry '${optional_path}' does not exist at ${TEMPLATE_DIR}/${optional_path}"
done <<<"${OPTIONAL_PATHS}"

# Every ${templateOption:x} placeholder used under the template dir must be a
# declared option, and every declared option must be referenced somewhere.
USED_PLACEHOLDERS="$(grep -rhoE '\$\{templateOption:[A-Za-z0-9_]+\}' "${TEMPLATE_DIR}" 2>/dev/null \
    | sed -E 's/\$\{templateOption:([A-Za-z0-9_]+)\}/\1/' | sort -u || true)"

while IFS= read -r placeholder; do
    [ -z "${placeholder}" ] && continue
    if ! grep -qxF "${placeholder}" <<<"${OPTION_KEYS}"; then
        fail "Placeholder '\${templateOption:${placeholder}}' used in ${TEMPLATE_DIR} is not declared in 'options'"
    fi
done <<<"${USED_PLACEHOLDERS}"

while IFS= read -r option; do
    [ -z "${option}" ] && continue
    if ! grep -qxF "${option}" <<<"${USED_PLACEHOLDERS}"; then
        fail "Option '${option}' declared in ${MANIFEST} is never referenced as \${templateOption:${option}} under ${TEMPLATE_DIR}"
    fi
done <<<"${OPTION_KEYS}"

# Version must be bumped relative to base ref, unless the template is new.
if PREV_MANIFEST="$(git show "${BASE_REF}:${MANIFEST}" 2>/dev/null)"; then
    PREV_VERSION="$(jq -r '.version // empty' <<<"${PREV_MANIFEST}")"
    if [ -n "${PREV_VERSION}" ]; then
        HIGHEST="$(printf '%s\n%s\n' "${PREV_VERSION}" "${VERSION}" | sort -V | tail -n1)"
        if [ "${VERSION}" = "${PREV_VERSION}" ] || [ "${HIGHEST}" != "${VERSION}" ]; then
            fail "'version' in ${MANIFEST} (${VERSION}) was not bumped above the version on the base branch (${PREV_VERSION}). Bump 'version' in ${MANIFEST}."
        fi
    fi
else
    echo "(*) ${TEMPLATE_ID} does not exist on the base branch; treating as a new template, skipping version-bump check."
fi

echo "(*) ${TEMPLATE_ID}: OK (version ${VERSION})"
