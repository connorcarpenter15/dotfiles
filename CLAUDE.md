# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Cross-platform dotfiles (macOS + Linux, x86_64 + aarch64) bootstrapped by a single
`./install` script. There are two install paths and both are still in active use —
keep them in sync when adding managed config files.

## Bootstrap & common commands

```sh
./install                       # full bootstrap (submodules + symlinks + Home Manager + terminfo)
./install --overwrite-from-home # repo file differs from $HOME → copy home → repo, then link
./install --force               # replace foreign symlinks, back up existing ~/.config/nvim
bin/install-ghostty-terminfo    # reinstall just the xterm-ghostty terminfo entry
git submodule update --init --recursive   # if cloned without --recurse-submodules
```

Apply Home Manager directly (rarely needed — `./install` does this):

```sh
DOTFILES_DIR="$PWD" nix --extra-experimental-features 'nix-command flakes' \
  run .#home-manager -- switch --flake .#<system> --impure
# <system> ∈ {aarch64-darwin, x86_64-darwin, aarch64-linux, x86_64-linux}
```

There is no test suite, linter, or formatter wired up. `nix fmt` runs `nixfmt`
on `.nix` files (exposed via the flake's `formatter` output).

## Two install paths — keep both wired up

`./install` does three things in order:

1. **Submodule init** — `git submodule update --init --recursive` (for `external/nvim`).
2. **MANIFEST symlinks** (`link_manifest` in `install`) — tab-separated
   `repo_path<TAB>$HOME-relative_path` pairs in `MANIFEST`. Used as fallback when
   Nix is missing. Also bootstraps the repo file from `$HOME` if the repo file
   doesn't exist yet.
3. **Home Manager** (when `nix` is found) — runs the flake's `home-manager` app
   with `switch --flake .#<detected-system> --impure`. This is the primary path
   and installs packages + writes the symlinks via `home.file` in `nix/home.nix`.

**When you add a new managed dotfile, update BOTH places:**

- Add a row to `MANIFEST` (`repo_path<TAB>target_under_HOME`).
- Add an entry to `home.file` in `nix/home.nix` using
  `managedLink (linkSource "<repo_path>")`.

If you only update one, machines on the other path will silently lose the file.

## Important architectural notes

- **Neovim lives in its own repo** at `external/nvim` (submodule, relative URL
  `../nvim.git`). Home Manager links the submodule directory to `~/.config/nvim`
  via an out-of-store symlink. Do not commit changes to the Neovim config from
  this repo — make them in the nvim submodule and update the pointer here.
- **Out-of-store symlinks** — `nix/home.nix` uses `mkOutOfStoreSymlink` with
  `dotfilesPath` (either `$DOTFILES_DIR` or the flake's `self.outPath`) so that
  edits to repo files take effect without rebuilding. That's why `--impure` is
  required when running `home-manager switch`.
- **Optional Nix packages** — `nix/home.nix` uses `optionalPkg` /
  `optionalNestedPkg` helpers so a package that disappears from `nixpkgs` (or
  moves between top-level and `nodePackages`/`python3Packages`) doesn't break
  the whole build. When adding a package, prefer the helper pattern over a bare
  reference.
- **Local overrides** — `~/.shellrc.local` and `~/.profile.local` are sourced
  if present. Machine-specific settings go there, not in tracked files.
- **Terminfo** — `bin/install-ghostty-terminfo` compiles
  `terminfo/xterm-ghostty.terminfo` into `${TERMINFO:-$HOME/.terminfo}` so
  remote hosts without a Ghostty entry render correctly over SSH.

## Shell file load order

`.zshenv` / `.bash_profile` source `.profile`; interactive shells source
`.shellrc` from `.zshrc` / `.bashrc`. Common environment, PATH, aliases, and the
`t` tmux helper live in `.shellrc` so both shells stay aligned. Don't duplicate
shell-specific logic across files — put shared bits in `.shellrc`.

## Git commits

Use Conventional Commits (`type(scope): description` or `type: description`).
Always sign off: `git commit -s` (or `--amend --signoff` when amending).
