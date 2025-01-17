
# Python (python)

An opinionated and perosnal image for Python development

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| pythonVersion | Python verison to be used: | string | 3.13 |
| imageVariant | Debian version (use bullseye on local arm64/Apple Silicon): | string | bookworm |

# Using this template

Practical example:

```bash
# Create a project called pyfoo, adjust `uv init` to your needs
uv init pyfoo && cd pyfoo
# Apply the template using the devcontainer-cli
devcontainer templates apply --template-id ghcr.io/mmartinortiz/devcontainer-templates/python
```

This will create a basic structure using `uv`, and apply this template to enable development using devcontainer.


---

_Note: This file was auto-generated from the [devcontainer-template.json](https://github.com/mmartinortiz/devcontainer-templates/blob/main/src/python/devcontainer-template.json).  Add additional notes to a `NOTES.md`._
