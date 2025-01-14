
# My Python template

An opinionated template for Python development.

Features:

- [uv](https://docs.astral.sh/)
- [fish](https://fishshell.com/)
- [starship](https://starship.rs/)

VS Code customizations:

- Pytest as test suit
- `fish` as default development
- Set default Python interpreter to the `.venv` interpreter
- Format code on save using [ruff](https://docs.astral.sh/ruff/)

## Options

| Options Id    | Description                                                 | Type   | Default Value |
|---------------|-------------------------------------------------------------|--------|---------------|
| imageVariant  | Debian version (use bullseye on local arm64/Apple Silicon): | string | bookworm      |
| pythonVersion | Python version                                              | string | 3.13          |

---

_Note: This file was auto-generated from the [devcontainer-template.json](https://github.com/devcontainers/template-starter/blob/main/src/color/devcontainer-template.json).  Add additional notes to a `NOTES.md`._
