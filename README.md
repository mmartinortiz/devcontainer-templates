# Personal Dev Container templates

This repository contains my personal [Dev Container Templates](https://containers.dev/implementors/templates) with some personal preferences for my projects regarding features (like the Fish shell) or settings.

You can apply a template using the [devcontainer-cli](https://github.com/devcontainers/cli), e.g.:

```bash
# Create a repo for your project
mkdir myproject && cd myproject

# Not mandatory, but nice if you use a VCS, like Git
git init

# Apply a template using the devcontainer-cli
devcontainer templates apply --template-id ghcr.io/mmartinortiz/devcontainer-templates/<template-id>
```

Available templates, with their `<template-id>` and options:

- [`python`](./src/python/README.md)
- [`base`](./src/base/README.md) — general-purpose template built on this repo's own [base image](./images/base/README.md)

## Base image

This repo also publishes an opinionated Ubuntu base [Dev Container image](https://ghcr.io/mmartinortiz/devcontainer-images/base) (fish, vim, uv, starship, prek, opencode), usable directly via `"image": "ghcr.io/mmartinortiz/devcontainer-images/base"` without going through a template. See [images/base/README.md](./images/base/README.md) for details.

This repository is a fork from the [Dev Container Self Authoring guide](https://github.com/devcontainers/template-starter).
