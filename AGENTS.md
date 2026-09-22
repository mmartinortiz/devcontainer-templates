# AGENTS.md

Repo hosts personal [Dev Container Templates](https://containers.dev/implementors/templates). Only template today: `src/python`.

## Structure

- `src/<template-id>/` — one dir per template.
  - `devcontainer-template.json` — template metadata, `options` (with `proposals`/`default`), `optionalPaths`.
  - `.devcontainer/devcontainer.json` — the actual content applied to consumer projects. Contains `${templateOption:x}` placeholders resolved from the above options.
  - `.cz.toml` — **per-template** commitizen config (not at repo root).
- `test/<template-id>/test.sh` — smoke-test assertions for that template.
- `test/test-utils/test-utils.sh` — shared `check()` / `reportResults()` bash helpers, copied alongside `test.sh` at test time.

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

CI (`test-pr.yaml`) runs this per template, matrixed only over templates whose files changed (via `dorny/paths-filter`). There is no other lint/build/typecheck target — this repo is templates + tests only.

## Versioning / commits

- Conventional Commits enforced by the `commitizen` pre-commit hook (root `.pre-commit-config.yaml`).
- Don't hand-bump version fields in `devcontainer-template.json`: `bump.yaml` auto-bumps on push to `main` touching `src/**` (skipped if the triggering commit message starts with `bump:`), tagging as `template_python_<version>`.
- Adding a new `options` entry in `devcontainer-template.json` requires a valid `default` — `build.sh` exits 1 otherwise (defaults get sed-substituted into every file under the template dir before the smoke test builds it).

## Release flow (informational — not something to run locally)

Merging to `main` with `src/**` changes triggers `release.yaml`: publishes templates, regenerates docs, and opens a PR updating template `README.md` files. Expect those READMEs to be periodically regenerated.
