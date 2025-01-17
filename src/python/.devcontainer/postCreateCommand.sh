#!/bin/bash
echo "
format = \"\$git_branch \$git_status\\n> \"
" > ~/.config/starship.toml

echo "
starship init fish | source
" >> ~/.config/fish/config.fish

if [ -e pyproject.toml ]; then
    uv generate-shell-completion fish > ~/.config/fish/completions/uv.fish
    uv sync --all-groups --link-mode=copy
fi
