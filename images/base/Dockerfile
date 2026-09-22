# Pulls the static uv/uvx binaries from Astral's distroless image.
ARG UV_IMAGE_TAG=0.12.17
FROM ghcr.io/astral-sh/uv:${UV_IMAGE_TAG} AS uv

FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Re-declare after FROM (build args are scoped per stage).
ARG STARSHIP_VERSION=1.26.0
ARG PREK_VERSION=0.5.3
ARG OPENCODE_VERSION=1.18.32

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
    tar -xzf /tmp/starship.tar.gz -C /usr/local/bin starship; \
    rm /tmp/starship.tar.gz; \
    chmod +x /usr/local/bin/starship

# opencode: fetch the pinned GitHub release tarball for the current architecture.
# Assets are glibc builds (matching this Ubuntu base); musl/baseline variants exist but aren't needed here.
RUN set -eux; \
    case "$(dpkg --print-architecture)" in \
        amd64) OC_ARCH=linux-x64 ;; \
        arm64) OC_ARCH=linux-arm64 ;; \
        *) echo "Unsupported architecture: $(dpkg --print-architecture)" >&2; exit 1 ;; \
    esac; \
    curl -fsSL \
        "https://github.com/anomalyco/opencode/releases/download/v${OPENCODE_VERSION}/opencode-${OC_ARCH}.tar.gz" \
        -o /tmp/opencode.tar.gz; \
    tar -xzf /tmp/opencode.tar.gz -C /usr/local/bin opencode; \
    rm /tmp/opencode.tar.gz; \
    chmod +x /usr/local/bin/opencode

# Fish completions for uv (uvx has no completion generator of its own; it proxies to `uv tool run`).
RUN mkdir -p /usr/share/fish/vendor_completions.d \
    && uv generate-shell-completion fish > /usr/share/fish/vendor_completions.d/uv.fish

# prek, installed as a uv tool directly into /usr/local/bin.
# UV_TOOL_DIR is moved out of /root so the non-root vscode user can still exec the tool venv
# that /usr/local/bin/prek symlinks into.
ENV UV_TOOL_DIR=/opt/uv-tools
ENV UV_TOOL_BIN_DIR=/usr/local/bin
RUN uv tool install "prek${PREK_VERSION:+==${PREK_VERSION}}" \
    && chmod -R o+rX /opt/uv-tools \
    && COMPLETE=fish prek > /usr/share/fish/vendor_completions.d/prek.fish

# Default user setup: fish as default shell, ~/.local/bin on PATH.
RUN chsh --shell "$(command -v fish)" vscode
ENV PATH="/home/vscode/.local/bin:${PATH}"

USER vscode
