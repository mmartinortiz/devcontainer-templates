# Pulls the static uv/uvx binaries from Astral's distroless image.
ARG UV_IMAGE_TAG=0.12.23
FROM ghcr.io/astral-sh/uv:${UV_IMAGE_TAG} AS uv

FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Re-declare after FROM (build args are scoped per stage).
# UV_IMAGE_TAG has no default here: it's only used below to label the image with the
# same value used to select the uv builder stage's FROM tag above.
ARG UV_IMAGE_TAG
ARG STARSHIP_VERSION=1.26.0
ARG PREK_VERSION=0.5.5
ARG OPENCODE_VERSION=2.0.24
# sha512 of the per-arch npm tarballs, from `dist.integrity` of
# `@opencode/cli-linux-{x64,arm64}` (SRI format, base64). Verified at build time.
ARG OPENCODE_SHA512_X64=WDBunGoImJOYjwUvDDfl0GJiKR/WbATnSXW1QTrK+VDp+oOUNLXo84QTUCBVUqvb8VsseWhs3uyWCD9o9c5JDA==
ARG OPENCODE_SHA512_ARM64=n+C1XkoIB0NaHK9CQo4gGIc9FRGDhrMdCXO8heEOvUgKsH/0ROxCr3CxUuJaKolL/5+c5u3CoiXsckL+fa52ag==
ARG DELTA_VERSION=0.20.1
# sha256 of the per-arch release tarballs, from the GitHub release's asset `digest`
# field. Verified at build time. Starship needs no pin: upstream publishes a `.sha256`
# sidecar next to each asset, fetched and checked at build time instead.
ARG DELTA_SHA256_AMD64=50f08c879f84c81ceb220e476491a7f492d2c9c671e79918cc44badf961a6240
ARG DELTA_SHA256_ARM64=da7f4338f593572ff426ae153e0870e2fdc72729416eff551b40cdeb67940db8

# OCI labels: bake the exact tool versions into the image so they're inspectable without
# pulling and running each binary's --version (`docker inspect <image>` or GHCR's package page).
LABEL org.opencontainers.image.title="devcontainer-base" \
  org.opencontainers.image.description="Ubuntu dev container base image — uv/uvx ${UV_IMAGE_TAG}, starship ${STARSHIP_VERSION}, prek ${PREK_VERSION}, opencode ${OPENCODE_VERSION}, delta ${DELTA_VERSION}" \
  org.opencontainers.image.source="https://github.com/mmartinortiz/devcontainer-templates"

USER root

# fish + vim via apt. curl/ca-certificates are needed to fetch the starship release tarball.
RUN apt-get update \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get -y install --no-install-recommends \
  fish \
  vim \
  curl \
  ca-certificates \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*

# Vim defaults: line numbers, wrap, blinking bar cursor in insert mode.
# Ubuntu's packaged /etc/vim/vimrc sources /etc/vim/vimrc.local if present, so this
# applies system-wide without touching the package-managed vimrc.
COPY vimrc.local /etc/vim/vimrc.local

# uv / uvx, copied from the official distroless image.
COPY --from=uv /uv /uvx /usr/local/bin/

# starship: fetch the pinned GitHub release tarball for the current architecture.
RUN set -eux; \
  case "$(dpkg --print-architecture)" in \
  amd64) SS_ARCH=x86_64-unknown-linux-musl ;; \
  arm64) SS_ARCH=aarch64-unknown-linux-musl ;; \
  *) echo "Unsupported architecture: $(dpkg --print-architecture)" >&2; exit 1 ;; \
  esac; \
  curl -fsSL \
  "https://github.com/starship/starship/releases/download/v${STARSHIP_VERSION}/starship-${SS_ARCH}.tar.gz" \
  -o /tmp/starship.tar.gz; \
  # Verify against upstream's published .sha256 sidecar (bare hash, no filename).
  SS_SHA256="$(curl -fsSL "https://github.com/starship/starship/releases/download/v${STARSHIP_VERSION}/starship-${SS_ARCH}.tar.gz.sha256")"; \
  echo "${SS_SHA256}  /tmp/starship.tar.gz" | sha256sum -c -; \
  tar -xzf /tmp/starship.tar.gz -C /usr/local/bin starship; \
  rm /tmp/starship.tar.gz; \
  chmod +x /usr/local/bin/starship

# opencode: fetch the pinned npm tarball for the current architecture.
# V2 is published as Git tags only (no GitHub Releases), so binaries are pulled from the
# per-platform npm packages `@opencode/cli-linux-{x64,arm64}` instead of a release asset.
# "Latest V2" is resolved via https://opencode.ai/update/api/latest/cli/npm — see
# .github/workflows/update-base-image-versions.yaml. Assets are glibc builds (matching
# this Ubuntu base).
RUN set -eux; \
  case "$(dpkg --print-architecture)" in \
  amd64) OC_ARCH=x64; OC_SHA512="${OPENCODE_SHA512_X64}" ;; \
  arm64) OC_ARCH=arm64; OC_SHA512="${OPENCODE_SHA512_ARM64}" ;; \
  *) echo "Unsupported architecture: $(dpkg --print-architecture)" >&2; exit 1 ;; \
  esac; \
  curl -fsSL \
  "https://registry.npmjs.org/@opencode/cli-linux-${OC_ARCH}/-/cli-linux-${OC_ARCH}-${OPENCODE_VERSION}.tgz" \
  -o /tmp/opencode.tgz; \
  # Verify against the pinned sha512 (npm SRI string, base64 — decode to hex for sha512sum).
  echo "$(echo "${OC_SHA512}" | base64 -d | od -An -tx1 -v | tr -d ' \n')  /tmp/opencode.tgz" | sha512sum -c -; \
  tar -xzf /tmp/opencode.tgz -C /usr/local/bin --strip-components=2 package/bin/opencode; \
  rm /tmp/opencode.tgz; \
  chmod +x /usr/local/bin/opencode

# delta: fetch the pinned GitHub release tarball for the current architecture.
# Release tags have no "v" prefix (unlike starship above). Only gnu (not musl)
# linux targets are published for aarch64, so use gnu for both architectures here.
RUN set -eux; \
  case "$(dpkg --print-architecture)" in \
  amd64) DELTA_ARCH=x86_64-unknown-linux-gnu; DELTA_SHA256="${DELTA_SHA256_AMD64}" ;; \
  arm64) DELTA_ARCH=aarch64-unknown-linux-gnu; DELTA_SHA256="${DELTA_SHA256_ARM64}" ;; \
  *) echo "Unsupported architecture: $(dpkg --print-architecture)" >&2; exit 1 ;; \
  esac; \
  curl -fsSL \
  "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/delta-${DELTA_VERSION}-${DELTA_ARCH}.tar.gz" \
  -o /tmp/delta.tar.gz; \
  # Verify against the pinned sha256 (GitHub release asset digest).
  echo "${DELTA_SHA256}  /tmp/delta.tar.gz" | sha256sum -c -; \
  tar -xzf /tmp/delta.tar.gz -C /usr/local/bin --strip-components=1 "delta-${DELTA_VERSION}-${DELTA_ARCH}/delta"; \
  rm /tmp/delta.tar.gz; \
  chmod +x /usr/local/bin/delta

# Wire delta into git system-wide as the pager/diff filter. Uses `git config --system`
# (appends to /etc/gitconfig) rather than COPYing a full gitconfig, so it doesn't clobber
# any entries the base image already set there; a user's own ~/.gitconfig still overrides this.
RUN git config --system core.pager delta \
  && git config --system interactive.diffFilter "delta --color-only" \
  && git config --system delta.navigate true \
  && git config --system merge.conflictstyle zdiff3
# merge.conflictstyle=zdiff3 is unrelated to delta itself (it's a native git merge-marker
# format, not something delta renders) but is bundled here since delta's docs recommend
# pairing it: zdiff3 conflict markers include the common ancestor hunk, which delta can
# then diff-highlight for easier conflict resolution. This changes conflict marker output
# for *all* merges/rebases in the container, regardless of whether delta is used as pager.

# Fish completions for uv (uvx has no completion generator of its own; it proxies to `uv tool run`)
# and delta.
RUN mkdir -p /usr/share/fish/vendor_completions.d \
  && uv generate-shell-completion fish > /usr/share/fish/vendor_completions.d/uv.fish \
  && delta --generate-completion fish > /usr/share/fish/vendor_completions.d/delta.fish

# prek, installed as a uv tool. UV_TOOL_DIR is moved out of /root so the non-root vscode user
# can still exec the tool venv, and both it and UV_TOOL_BIN_DIR point at vscode-owned
# locations (not /usr/local/bin, a root-owned system dir) since vscode is the only user that
# ever runs uv/prek at runtime and needs to write to both: prek rewrites files inside its own
# venv dir on invocation, and consumer devcontainer.json onCreateCommand steps commonly
# `uv tool install` further tools (e.g. rust-just) here as vscode. UV_TOOL_BIN_DIR is
# ~/.local/bin (already on PATH below) rather than /opt/uv-tools itself so installed tools'
# symlinks land somewhere every shell already looks, same as a plain `uv tool install` a user
# would run themselves.
ENV UV_TOOL_DIR=/opt/uv-tools
ENV UV_TOOL_BIN_DIR=/home/vscode/.local/bin
# ~/.local/bin on PATH — needed now already so `prek` (just installed there) is runnable
# below to generate its own completions, not just later at container runtime.
ENV PATH="/home/vscode/.local/bin:${PATH}"
RUN uv tool install "prek${PREK_VERSION:+==${PREK_VERSION}}" \
  && chown -R vscode:vscode /opt/uv-tools \
  && COMPLETE=fish prek > /usr/share/fish/vendor_completions.d/prek.fish

# Pre-create the XDG dirs owned by vscode. Docker creates missing parent directories of
# bind/volume mount targets as root:root, so a consumer mounting e.g.
# ~/.local/share/opencode would otherwise leave ~/.local root-owned and unwritable,
# breaking tools that write to ~/.local/state (opencode: EACCES mkdir).
RUN install -d -o vscode -g vscode \
  /home/vscode/.local \
  /home/vscode/.local/bin \
  /home/vscode/.local/share \
  /home/vscode/.local/state \
  /home/vscode/.cache \
  /home/vscode/.config

USER vscode
