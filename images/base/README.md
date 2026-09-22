# Base Dev Container image

Opinionated Ubuntu-based Dev Container base image (`mcr.microsoft.com/devcontainers/base:ubuntu`) with:

- [Fish shell](https://fishshell.com/) (apt), set as the default shell for the `vscode` user
- [vim](https://www.vim.org/) (apt)
- [uv / uvx](https://docs.astral.sh/uv/) (copied from `ghcr.io/astral-sh/uv`), with fish completions
- [Starship](https://starship.rs/) prompt (pinned GitHub release binary)
- [prek](https://github.com/j178/prek) (installed via `uv tool install`), with fish completions

## Usage

Reference the published image directly in your `devcontainer.json`:

```jsonc
{
  "image": "ghcr.io/mmartinortiz/devcontainer-images/base:latest"
}
```

## Build arguments

| Arg               | Default  | Purpose                                                        |
| ----------------- | -------- | --------------------------------------------------------------- |
| `UV_IMAGE_TAG`    | `latest` | Tag of `ghcr.io/astral-sh/uv` to copy the `uv`/`uvx` binaries from |
| `STARSHIP_VERSION`| `1.26.0` | Starship GitHub release version to install (without the `v` prefix) |
| `PREK_VERSION`    | *(unset)* | Pin a specific `prek` version; empty installs the latest from PyPI |

Build locally, e.g. to bump Starship:

```bash
docker build --build-arg STARSHIP_VERSION=1.27.0 -t devcontainer-base images/base
```
