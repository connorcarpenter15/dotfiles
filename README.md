# dotfiles

Cross-platform dotfiles for bootstrapping a new macOS or Linux shell account
with one command. The repository uses a small `./install` bootstrap plus a Nix
flake with standalone Home Manager for package installation and config links.

## What is included

- Shell startup files for zsh and Bash
- Git, Starship, Codex, Ghostty, and tmux config
- Ghostty `xterm-ghostty` terminfo installation for remote hosts
- Neovim config as a Git submodule at `external/nvim`
- Home Manager packages for the shell and editor toolchain, including
  `starship`, `neovim`, `fzf`, `fd`, `ripgrep`, `zoxide`, `direnv`, `lazygit`,
  `eza`, `yazi`, `trash-cli`, `btop`, `git`, `delta`, `tmux`, and common Neovim
  language servers, formatters, and linters

The legacy manifest in [`MANIFEST`](MANIFEST) still describes the single-file
configs. Nix/Home Manager is now the primary path when Nix is available.

## Install

Clone the repo:

```sh
git clone --recurse-submodules <your-remote-url> ~/dotfiles
cd ~/dotfiles
./install
```

If you already cloned without submodules, `./install` will run:

```sh
git submodule update --init --recursive
```

If Nix is installed, `./install` applies the Home Manager flake for the current
platform. If Nix is missing, it applies the legacy symlinks, links the Neovim
submodule when safe, installs Ghostty terminfo, and prints the official Nix
installer command to run before rerunning `./install`.

The bootstrap supports:

- `aarch64-darwin`
- `x86_64-darwin`
- `aarch64-linux`
- `x86_64-linux`

## Neovim

Neovim remains its own repository, nested here as a submodule:

```sh
external/nvim -> ../nvim.git
```

That relative URL lets Git reuse the same transport you used for this dotfiles
repo, such as SSH or HTTPS. Home Manager links `external/nvim` to
`~/.config/nvim`.

If `~/.config/nvim` already exists as a separate checkout with uncommitted
changes, `./install` refuses to replace it. Commit or stash those changes first,
or run `./install --force` to back the directory up before linking the
submodule.

## tmux

tmux is installed through Home Manager and configured by `~/.tmux.conf`.
Start or reattach to the default session with:

```sh
t
```

Use `t work` for a named session. The config keeps the stock `Ctrl-b` prefix.
Press `Ctrl-b Esc` to enter vi copy-mode, then use motions such as `hjkl`,
`/`, `n`, `gg`, `G`, `v`, `y`, and `q` to navigate, search, select, copy, and
exit terminal scrollback.

## Local Overrides

Machine-specific settings should stay out of Git:

- `~/.shellrc.local`
- `~/.profile.local`

These are sourced automatically when present.

## Options

- `--overwrite-from-home`: if a managed single-file config in `$HOME` differs
  from this repo, copy home -> repo, then link.
- `--force`: keep the repository version, backing up divergent managed files,
  foreign symlinks, and existing Neovim directories before linking.

## Manual Commands

Apply Home Manager directly:

```sh
DOTFILES_DIR="$PWD" nix --extra-experimental-features nix-command --extra-experimental-features flakes \
  run .#home-manager -- switch --flake .#aarch64-darwin --impure
```

Replace `aarch64-darwin` with your system from the supported list above. In
practice, prefer `./install`; it handles platform detection, submodules, safe
migration checks, and Ghostty terminfo.

Reinstall only Ghostty terminfo:

```sh
bin/install-ghostty-terminfo
```
