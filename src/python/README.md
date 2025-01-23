
# Python (python)

An opinionated and personal image for Python development

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| pythonVersion | Python verison to be used: | string | 3.13 |
| imageVariant | Debian version (use bullseye on local arm64/Apple Silicon): | string | bookworm |

## What it brings

Features like:

- [uv](https://docs.astral.sh/)
- [Fish Shell](https://fishshell.com/)
- [Starship](https://starship.rs/)
- [Tox](https://tox.wiki/en/4.24.1/) Disabled by default, just uncoment the corresponding line before building your container
- [pre-commit](https://pre-commit.com/) Disabled by default, just uncomment the line before building your container

Extensions like:

- [MS Python](https://marketplace.visualstudio.com/items?itemName=ms-python.python)
- [Python Autodocstring](https://marketplace.visualstudio.com/items?itemName=njpwerner.autodocstring)
- [Ruff](https://marketplace.visualstudio.com/items?itemName=charliermarsh.ruff)
- [Better Toml](https://marketplace.visualstudio.com/items?itemName=tamasfe.even-better-toml)
- [Markdown all in one](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one)
- [Code Spell Cheker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker)

Settings for VS Code like:

- Format Python code with Ruff
- Format on save
- Set the default interpreter to the created by `uv`
- Use Pytest
- Default shell set to Fish

## Using this template

Practical example:

Create a directory for your project.

```bash
mkdir pyfoo && cd pyfoo
```

Apply the template using the devcontainer-cli. This will download this template and save it locally, you will need to have installed the [devcontainer-cli](https://github.com/devcontainers/cli). If you do not have it or do not want to install it, just download the `.devcontainer` folder and its content into your project's root folder.

```bash
devcontainer templates apply --template-id ghcr.io/mmartinortiz/devcontainer-templates/python
```

Use an IDE with Devcontainers support like VS Code. If you is PyCharm, just be aware that the settings of this template will have to be changed to PyCharm style.

VS Code will ask you to reopen the project in the container, click on the button and the devcontainer will be built. This template is a starting point, from here, modify the `.devcontainer/devcontainer.json` file to fit your project's needs.

```bash
code .
```

The first time the container start, there is nothing there besides the devcontainer definition, but all the tools are ready to be used. Remember to uncomment `tox` and/or `pre-commit` in the `devcontainer.json` if you want to use it for testing. Start creating a new project with `uv`, add some packages for your project, etc.

```bash
uv init --name mypackage --package --build-backend setuptools --no-pin-python --vcs git
```


---

_Note: This file was auto-generated from the [devcontainer-template.json](https://github.com/mmartinortiz/devcontainer-templates/blob/main/src/python/devcontainer-template.json).  Add additional notes to a `NOTES.md`._
