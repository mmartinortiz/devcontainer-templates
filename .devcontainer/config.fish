# Ensure user-local binaries are on PATH
fish_add_path ~/.local/bin

# Aliases
alias pre-commit prek

# Prompt
starship init fish | source
