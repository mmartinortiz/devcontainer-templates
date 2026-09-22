#!/bin/bash
mkdir -p ~/.config/fish
cp .devcontainer/starship.toml ~/.config/starship.toml
cp .devcontainer/config.fish ~/.config/fish/config.fish

npm install -g @devcontainers/cli
