## What it brings

Features like:

- [uv](https://docs.astral.sh/)
- [Fish Shell](https://fishshell.com/)
- [Starship](https://starship.rs/)

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
# Not mandatory, but nice if you use a VCS, like Git
git init
# Apply the template using the devcontainer-cli
devcontainer templates apply --template-id ghcr.io/mmartinortiz/devcontainer-templates/python
```

Now you can build the devcontainer template for your Python project.
