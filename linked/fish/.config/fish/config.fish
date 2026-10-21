set -gx EDITOR nvim

# `\cj` instead of `ctrl-j`, so it also works with fish < 4.0
bind \cj accept-autosuggestion

# aliases
# working with .dotfiles
alias hgit="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

alias n="nvim"
alias d="docker"
alias pac="pacman"
alias dc="docker compose"
alias p="pnpm"
alias px="pnpm exec"

alias gav="git add -v"
alias gcn!="git commit --amend --no-edit"
alias gpsup="git push"
alias gpsupf="git push --force-with-lease"
alias gco="git checkout"
alias gcm="git commit"
alias grhh="git reset --hard"

alias k=kubectl

alias src="source ~/.config/fish/config.fish"

alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

set -gx PNPM_HOME "$HOME/.local/share/pnpm"

# -P edits PATH directly instead of the universal fish_user_paths.
# Directories that don't exist are skipped.
fish_add_path -P $PNPM_HOME $HOME/.ghcup/bin
fish_add_path -P $HOME/.local/bin /usr/local/go/bin $HOME/go/bin
