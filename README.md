# dotfiles

Configs managed with [GNU Stow](https://www.gnu.org/software/stow/).

Each directory in `linked/` mirrors `~`, e.g. `linked/nvim/.config/nvim` is linked to `~/.config/nvim`.

## Install

```sh
sudo apt install stow  # or: sudo pacman -S stow
git clone <remote> ~/repos/dotfiles
make -C ~/repos/dotfiles link  # or: link PACKAGES="nvim"
```

Stow will not overwrite existing configs, so move them away first.
