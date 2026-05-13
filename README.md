# dotfiles

Single-file configuration files for this machine, symlinked from `$HOME` (and
XDG config paths) into this repository so edits stay version-controlled.

## What is included

Files managed by [`install`](install) are listed in [`MANIFEST`](MANIFEST). Currently:

- Zsh and shell login files under `$HOME` (for example `.zshrc`, `.zshenv`,
  `.zprofile`, `.profile`, `.bash_profile`)
- Powerlevel10k theme config: `~/.p10k.zsh`
- Git user config: `~/.gitconfig`
- Ghostty: `~/.config/ghostty/config`

## What is excluded

- Neovim and other multi-file configs that live in their own repositories
- Anything not listed in `MANIFEST` (add a line there and re-run `./install` if
  you want another single-file config)

## First-time setup on this Mac

From this directory:

```sh
chmod +x install
./install
```

Options:

- `--overwrite-from-home` — if a file in `$HOME` differs from the copy in this
  repo, copy from home into the repo, then replace the home file with a symlink.
  Without this flag, `install` exits with an error when content differs.
- `--force` — if a target path is already a symlink pointing somewhere else,
  remove it and point it at this repo.

## Setup on another machine after clone

```sh
git clone <your-remote-url> ~/dotfiles
cd ~/dotfiles
chmod +x install
./install
```

If the repo already contains your files but this machine has no targets yet,
`install` creates parent directories and symlinks. If a target already exists
as a normal file and differs from the repo, use `--overwrite-from-home` once
(after backing up anything important) or merge manually.

## Adding another single-file config

1. Add a tab-separated line to `MANIFEST`:
   `path/inside/repo<TAB>path/relative/to/home` (for example
   `config/foo/bar.toml` and `.config/foo/bar.toml`).
2. Run `./install` again.
