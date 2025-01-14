FROM mcr.microsoft.com/devcontainers/python:1-${templateOption:pythonVersion}-${templateOption:imageVariant}

RUN <<eot
    echo 'format = \"\$git_branch \$git_status\\n> \"' > /home/vscode/.config/starship.toml
    mkdir -p /home/vscode/.config/fish
    echo 'starship init fish | source' >> /home/vscode/.config/fish/config.fish
eot
