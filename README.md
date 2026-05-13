# dotfiles

A small collection of single-file configuration files and an install script for
symlinking them from `$HOME` and XDG config paths into this repository. This is
meant to be easy to fork, copy from, or use as a reference for your own setup.

## Before you install

Review and customize the files before running [`install`](install), especially:

- `home/.gitconfig` for Git user identity and URL preferences
- `home/.p10k.zsh` for prompt layout and style
- Shell startup files for local paths, environment variables, or machine-specific
  assumptions

The install script only manages files listed in [`MANIFEST`](MANIFEST).

## What is included

Files managed by [`install`](install) are listed in [`MANIFEST`](MANIFEST). Currently:

- Zsh and shell login files under `$HOME` (for example `.zshrc`, `.zshenv`,
  `.zprofile`, `.profile`, `.bash_profile`)
- Powerlevel10k theme config: `~/.p10k.zsh`
- Git config: `~/.gitconfig`
- Ghostty terminal config: `~/.config/ghostty/config`

## What is excluded

- Neovim and other multi-file configs that live in their own repositories
- Anything not listed in `MANIFEST` (add a line there and re-run `./install` if
  you want another single-file config)

## Install

After cloning:

```sh
git clone <your-remote-url> ~/dotfiles
cd ~/dotfiles
chmod +x install
./install
```

If you are already in the repository:

```sh
chmod +x install
./install
```

Options:

- `--overwrite-from-home`: if a file in `$HOME` differs from the copy in this
  repo, copy from home into the repo, then replace the home file with a symlink.
  Without this flag, `install` exits with an error when content differs.
- `--force`: if a target path is already a symlink pointing somewhere else,
  remove it and point it at this repo.

If a target does not exist yet, `install` creates parent directories and
symlinks. If a target already exists as a normal file and differs from the repo,
use `--overwrite-from-home` once after backing up anything important, or merge
manually.

## Adding another single-file config

1. Add a tab-separated line to `MANIFEST`:
   `path/inside/repo<TAB>path/relative/to/home` (for example
   `config/foo/bar.toml` and `.config/foo/bar.toml`).
2. Run `./install` again.
