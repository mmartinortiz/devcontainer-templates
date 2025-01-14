FROM mcr.microsoft.com/devcontainers/python:1-${templateOption:pythonVersion}-${templateOption:imageVariant}

RUN <<eot bash
    echo "
    format = \"\$git_branch \$git_status\\n> \"
    " > /home/vscode/.config/starship.toml

    echo "
    starship init fish | source
    " >> /home/vscode/.config/fish/config.fish
eot
