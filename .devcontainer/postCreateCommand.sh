#!/bin/bash

npm install -g @devcontainers/cli

# Install pre-commit hooks
pre-commit install --install-hooks

# Eye candy for the command line
echo "
format = \"\$git_branch \$git_status\\n> \"
" > ~/.config/starship.toml

echo "
starship init fish | source
" >> ~/.config/fish/config.fish
