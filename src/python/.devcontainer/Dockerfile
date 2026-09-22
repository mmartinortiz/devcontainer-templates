ARG PYTHON_VERSION=3.13
ARG IMAGE_VARIANT=bookworm

FROM mcr.microsoft.com/devcontainers/python:1-${PYTHON_VERSION}-${IMAGE_VARIANT}

# The upstream base image ships an apt source for Yarn's classic repo
# (/etc/apt/sources.list.d/yarn.list) whose baked-in keyring no longer
# matches the repo's current signing key, so a plain `apt-get update`
# fails with "NO_PUBKEY 62D54FD4003F6525" / exit code 100. This breaks
# every devcontainer feature that runs `apt-get update` (e.g. the fish
# feature), since we don't use Yarn/Node in this template. Drop the source
# before any feature gets a chance to run apt-get update.
RUN rm -f /etc/apt/sources.list.d/yarn.list
