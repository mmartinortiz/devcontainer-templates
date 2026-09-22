# Base Dev Container image

Opinionated Ubuntu-based Dev Container base image (`mcr.microsoft.com/devcontainers/base:ubuntu`) with:

- [Fish shell](https://fishshell.com/) (apt), set as the default shell for the `vscode` user
- [vim](https://www.vim.org/) (apt), configured with line numbers, wrapped text, and a blinking bar cursor in insert mode (see `vimrc.local`)
- [uv / uvx](https://docs.astral.sh/uv/) (copied from `ghcr.io/astral-sh/uv`), with fish completions
- [Starship](https://starship.rs/) prompt (pinned GitHub release binary)
- [prek](https://github.com/j178/prek) (installed via `uv tool install`), with fish completions
- [opencode](https://opencode.ai) (pinned GitHub release binary)

## Usage

Reference the published image directly in your `devcontainer.json`:

```jsonc
{
  "image": "ghcr.io/mmartinortiz/devcontainer-images/base:latest"
}
```

Each merge to `main` also publishes a calendar-version tag (`YYYY.MM.DD`, UTC) alongside `latest`, e.g. `ghcr.io/mmartinortiz/devcontainer-images/base:2026.09.22`, so you can pin to a specific build if needed. Tags older than 3 months are pruned automatically by a monthly cleanup workflow (`latest` is never deleted).

The image also carries an `org.opencontainers.image.description` label listing the exact `uv`/`starship`/`prek`/`opencode` versions it was built with — check it via:

```bash
docker inspect ghcr.io/mmartinortiz/devcontainer-images/base:latest --format '{{.Config.Labels}}'
```

## Build arguments

| Arg               | Default  | Purpose                                                        |
| ----------------- | -------- | --------------------------------------------------------------- |
| `UV_IMAGE_TAG`    | `0.12.17` | Tag of `ghcr.io/astral-sh/uv` to copy the `uv`/`uvx` binaries from |
| `STARSHIP_VERSION`| `1.26.0` | Starship GitHub release version to install (without the `v` prefix) |
| `PREK_VERSION`    | `0.5.3`  | `prek` version to install from PyPI; leave empty to install the latest |
| `OPENCODE_VERSION`| `1.18.32` | opencode GitHub release version to install (without the `v` prefix) |

Build locally, e.g. to bump Starship:

```bash
docker build --build-arg STARSHIP_VERSION=1.27.0 -t devcontainer-base images/base
```
