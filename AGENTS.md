# AGENTS.md

Repo hosts personal [Dev Container Templates](https://containers.dev/implementors/templates) (`src/`) and Dev Container base images (`images/`). Only template today: `src/python`. Only image today: `images/base`.

## Structure

- `src/<template-id>/` — one dir per template.
  - `devcontainer-template.json` — template metadata, `options` (with `proposals`/`default`), `optionalPaths`.
  - `.devcontainer/devcontainer.json` — the actual content applied to consumer projects. Contains `${templateOption:x}` placeholders resolved from the above options.
- `test/<template-id>/test.sh` — smoke-test assertions for that template.
- `test/test-utils/test-utils.sh` — shared `check()` / `reportResults()` bash helpers, copied alongside `test.sh` at test time.
- `.github/actions/detect-templates/` — computes the JSON matrix of template ids affected by a PR (maps changed `src/<id>/**`/`test/<id>/**` paths to `<id>`; a change under `.github/actions/smoke-test/**` or `test/test-utils/**` affects *all* templates since it's shared test infra). Emits `[]` when nothing is affected.
- `.github/scripts/validate-template.sh <id> <base_ref>` — static checks on `src/<id>/devcontainer-template.json`: required fields, semver `version`, every `options.*` has a non-null `default`, every `optionalPaths` entry exists on disk, every `${templateOption:x}` placeholder under the template dir is declared (and vice versa), and `version` was bumped relative to `<base_ref>` (skipped for a template that doesn't exist there yet).

## Testing a template (no fast unit-test command — it's a full Docker build)

Requires Docker, `jq`, and `@devcontainers/cli` (npm). Flow lives in `.github/actions/smoke-test/`:

```bash
.github/actions/smoke-test/build.sh python   # copies src/python -> /tmp/python, sed-replaces
                                              # ${templateOption:*} with defaults from
                                              # devcontainer-template.json, copies test/python +
                                              # test/test-utils into /tmp/python/test-project,
                                              # then `devcontainer up`
.github/actions/smoke-test/test.sh python    # execs test-project/test.sh in the running
                                              # container, then force-removes it
```

CI (`.github/workflows/ci-templates.yaml`) runs `detect` → `validate` (fast, no Docker) → `smoke-test`, matrixed only over templates affected per `detect-templates`. A final `ci-templates-ok` job (`if: always()`) is the single required status check — needed because a dynamic matrix can't itself be set as a required check, and because a PR touching no template must still pass (an empty matrix used to hard-fail the workflow). There is no other lint/build/typecheck target — this repo is templates + tests only.

## Versioning / commits

- Conventional Commits enforced by the `commitizen` pre-commit hook (root `.pre-commit-config.yaml`) — message linting only, no auto-bumping.
- **Bump `version` in `devcontainer-template.json` by hand** whenever you change a template. `validate-template.sh` fails the PR if a changed template's `version` isn't strictly greater than the version on the PR base branch (new templates are exempt). No bot commits version bumps.
- Adding a new `options` entry requires a valid `default` and an actual `${templateOption:x}` reference somewhere under the template dir — both enforced by `validate-template.sh`, before any Docker build runs.

## Release flow (informational — not something to run locally)

Merging to `main` with `src/**` changes triggers `.github/workflows/release-templates.yaml`: runs `devcontainers/action` to publish templates to GHCR, tag the repo (`template_<id>_<version>`, via the action's own `disable-repo-tagging: false` — not a separate bump step), and regenerate docs, then opens a PR updating template `README.md` files. Expect those READMEs to be periodically regenerated.

## Base images (`images/<image-id>/`)

Distinct from Templates above — these are plain Dockerfiles (no `devcontainer-template.json`/options substitution), consumed by other projects via `"image": "ghcr.io/..."` in their `devcontainer.json`.

- `images/base/Dockerfile` — Ubuntu base (`mcr.microsoft.com/devcontainers/base:ubuntu`) + fish/vim (apt), uv/uvx (copied from `ghcr.io/astral-sh/uv`), Starship (pinned GitHub release binary), `prek` (via `uv tool install`, relocated `UV_TOOL_DIR=/opt/uv-tools` so the non-root `vscode` user can execute it — `uv tool install` defaults to `~root/.local/share/uv/tools`, unreadable by other users), and `opencode` (pinned GitHub release binary, glibc build — no fish completions since `opencode completion` is a yargs bash-only generator that ignores its shell argument). Also sets an `org.opencontainers.image.description` LABEL listing the exact versions of all four tools, generated from the same `ARG`s at build time (visible via `docker inspect`, no need to pull and run each `--version`). Pre-creates `~/.local`, `~/.local/bin`, `~/.local/share`, `~/.local/state`, `~/.cache`, `~/.config` owned by `vscode` before `USER vscode` — Docker creates missing bind/volume mount-point parent directories as `root:root`, so a consumer devcontainer mounting a volume under e.g. `~/.local/share/opencode` would otherwise leave `~/.local` root-owned, breaking tools (like opencode itself) that need to `mkdir` under `~/.local/state`.
- Since the published image is multi-arch (`linux/amd64,linux/arm64`), the Dockerfile `LABEL` alone isn't enough for GHCR's package page to show a description — GHCR reads that from OCI annotations on the manifest list/index, not from a single platform's image config. `release-images.yaml`'s `publish` job greps the same `ARG` defaults out of `images/base/Dockerfile` and passes them to `docker/build-push-action`'s `annotations:` input as `index,manifest:org.opencontainers.image.description=...` (both levels, for tool compatibility) — this workflow only runs on push to `main`, so there's no PR-time conditional needed. Verify with `docker buildx imagetools inspect <image> --raw` (a plain `docker inspect` after pulling only shows the per-platform `LABEL`, not the index annotation).
- Versions are pinned via build ARGs (`UV_IMAGE_TAG`, `STARSHIP_VERSION`, `PREK_VERSION`, `OPENCODE_VERSION`) with defaults baked in — bump these instead of relying on floating `latest` tags.
- Fish completions for `uv`/`prek` are generated at build time into `/usr/share/fish/vendor_completions.d/` (note: `vendor_completions.d`, not `vendoer_...`) via `uv generate-shell-completion fish` and `COMPLETE=fish prek` (prek has no static completion subcommand — it uses clap's dynamic `COMPLETE=<shell>` env convention). `uvx` has no completion generator of its own.
- `images/base/vimrc.local` is copied to `/etc/vim/vimrc.local` (Ubuntu's packaged `/etc/vim/vimrc` sources it if present, applying system-wide without touching the package-managed `vimrc`). Sets `number`/`wrap`, and a blinking vertical-bar cursor in insert mode via `t_SI`/`t_EI` DECSCUSR escape sequences (terminal-dependent, but supported by virtually all modern emulators including VS Code's integrated terminal). Test it with `vim --not-a-term -c '<ex commands>' -c quit!` — plain `vim -es` (Ex/batch mode) skips vimrc loading entirely, so it can't be used to verify these settings.
- `test/images/base/test.sh` — smoke test for the image: builds it (single-arch, or pass an already-built tag as `$1` to skip the build) and runs `docker run` checks via the same `check()`/`reportResults()` helpers from `test/test-utils/test-utils.sh` (sourced directly by relative path — not copied in, unlike the template test flow).
- `.github/workflows/ci-images.yaml` (PRs touching `images/**`) and `.github/workflows/release-images.yaml` (push to `main` touching `images/**`) both run a single-arch `test` job (`load: true`, runs `test/images/base/test.sh`) first. `ci-images.yaml` follows up with a `push: false` multi-arch build to catch arm64-only breakage without needing registry credentials. `release-images.yaml` follows up with the real multi-arch buildx push to GHCR, tagged both `latest` and a CalVer tag (`YYYY.MM.DD`, UTC, computed at build time) so individual builds stay pinnable and identifiable for cleanup.
- `.github/workflows/update-base-image-versions.yaml` runs weekly (and on `workflow_dispatch`): resolves the latest `uv`/`starship`/`prek`/`opencode` releases via the GitHub API, patches the `ARG` defaults in `images/base/Dockerfile` and the table in `images/base/README.md`, builds the image and runs the smoke test, then opens a PR (`peter-evans/create-pull-request`) if versions changed. PRs require manual review/merge — nothing auto-merges.
- `.github/workflows/cleanup-registry.yaml` runs monthly (and on `workflow_dispatch`, defaulting to `dry-run: true` for manual testing): uses `dataaxiom/ghcr-cleanup-action` to delete `devcontainer-images/base` package versions (CalVer tags + orphaned untagged children) older than 3 months, always excluding `latest`. **One-time manual prerequisite**: the GHCR package's own Settings → "Manage Actions access" must grant this repository the Admin role, otherwise the workflow's `GITHUB_TOKEN` cannot delete package versions (repo-level `packages: write` alone isn't sufficient).
