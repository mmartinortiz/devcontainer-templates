# Personal Dev Container templates

This repository contains my personal [Dev Container Templates](https://containers.dev/implementors/templates) with some personal preferences for my projects regarding features (like the Fish shell) or settings.

You can use, for example, the Python template in the following way using the [devcontainer-cli](https://github.com/devcontainers/cli):

```bash
# Create a repo for your project
mkdir pyfoo && cd pyfoo

# Not mandatory, but nice if you use a VCS, like Git
git init

# Apply the template using the devcontainer-cli
devcontainer templates apply --template-id ghcr.io/mmartinortiz/devcontainer-templates/python
```

Check out the different options at the template Readme:

- [Python](./src/python/README.md)

This repository is a fork from the [Dev Container Self Authoring guide](https://github.com/devcontainers/template-starter).
