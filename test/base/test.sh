#!/bin/bash
cd $(dirname "$0")
source test-utils.sh

# Template specific tests
check "distro" lsb_release -c
check "default shell is fish" [ "$(getent passwd "$(whoami)" | cut -d: -f7)" = "$(command -v fish)" ]
check "uv present" command -v uv
check "uvx present" command -v uvx
check "starship present" command -v starship
check "prek present" command -v prek
check "opencode present" command -v opencode
check "uv autocomplete fish" [ -e /usr/share/fish/vendor_completions.d/uv.fish ]
check "prek autocomplete fish" [ -e /usr/share/fish/vendor_completions.d/prek.fish ]
check "starship config copied" grep -qF '\[devcontainer\]' ~/.config/starship.toml
check "fish config copied" [ -e ~/.config/fish/config.fish ]
check "fish config inits starship" grep -q "starship init fish" ~/.config/fish/config.fish
check "fish config adds local bin to PATH" grep -q "fish_add_path ~/.local/bin" ~/.config/fish/config.fish
check "pre-commit alias resolves in fish" fish -c "type -q pre-commit"

# Report result
reportResults
