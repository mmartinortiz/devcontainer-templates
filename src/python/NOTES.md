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

```bash
# Create a repo for your project
mkdir pyfoo && cd pyfoo

# Apply the template using the devcontainer-cli
devcontainer templates apply --template-id ghcr.io/mmartinortiz/devcontainer-templates/python

# Create a project named mypackage using uv
uv init --name mypackage --package --build-backend setuptools --no-pin-python --vcs git

# Use an IDE with Devcontainers support like VS Code
code .
```

VS Code will ask you to reopen the project in the container, click on the button and you are ready to go. This tempalte is a starting point, from here, modify the `.devcontainer/devcontainer.json` file to fit your project's needs.
