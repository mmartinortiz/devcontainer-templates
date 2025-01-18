#!/bin/bash

npm install -g @devcontainers/cli

pre-commit install --install-hooks

echo "
format = \"\$git_branch \$git_status\\n> \"
" > ~/.config/starship.toml

echo "
starship init fish | source
" >> ~/.config/fish/config.fish
