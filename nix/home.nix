{
  config,
  lib,
  pkgs,
  dotfilesPath,
  ...
}:
let
  linkSource = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${path}";

  managedLink = source: {
    inherit source;
    force = true;
  };

  optionalPkg =
    name:
    if builtins.hasAttr name pkgs then
      let
        value = builtins.tryEval (builtins.getAttr name pkgs);
      in
      lib.optionals value.success [ value.value ]
    else
      [ ];

  optionalNestedPkg =
    setName: name:
    if builtins.hasAttr setName pkgs then
      let
        setValue = builtins.tryEval (builtins.getAttr setName pkgs);
      in
      if setValue.success && builtins.hasAttr name setValue.value then
        let
          value = builtins.tryEval (builtins.getAttr name setValue.value);
        in
        lib.optionals value.success [ value.value ]
      else
        [ ]
    else
      [ ];

  packageNames = [
    "starship"
    "neovim"
    "fzf"
    "fd"
    "ripgrep"
    "zoxide"
    "direnv"
    "lazygit"
    "eza"
    "yazi"
    "trash-cli"
    "btop"
    "git"
    "delta"
    "tmux"
    "curl"
    "wget"
    "unzip"
    "gzip"
    "gnutar"
    "gnumake"
    "ncurses"
    "tree-sitter"
    "nodejs"
    "python3"
    "deno"
    "rust-analyzer"
    "taplo"
    "marksman"
    "stylua"
    "shellcheck"
    "shfmt"
    "flake8"
    "black"
    "ruff"
    "ruff-lsp"
    "clang-tools"
    "prettier"
    "lua-language-server"
    "sql-formatter"
    "pyright"
    "vscode-langservers-extracted"
    "typescript-language-server"
    "typescript"
    "svelte-language-server"
    "tailwindcss-language-server"
    "bash-language-server"
    "yaml-language-server"
  ];

  nestedPackages =
    optionalNestedPkg "python3Packages" "flake8"
    ++ optionalNestedPkg "python3Packages" "black"
    ++ optionalNestedPkg "python3Packages" "ruff-lsp"
    ++ optionalNestedPkg "nodePackages" "prettier"
    ++ optionalNestedPkg "nodePackages" "sql-formatter"
    ++ optionalNestedPkg "nodePackages" "pyright"
    ++ optionalNestedPkg "nodePackages" "typescript-language-server"
    ++ optionalNestedPkg "nodePackages" "typescript"
    ++ optionalNestedPkg "nodePackages" "svelte-language-server"
    ++ optionalNestedPkg "nodePackages" "tailwindcss-language-server"
    ++ optionalNestedPkg "nodePackages" "bash-language-server"
    ++ optionalNestedPkg "nodePackages" "yaml-language-server";
in
{
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.packages = lib.concatMap optionalPkg packageNames ++ nestedPackages;

  home.sessionVariables = {
    EDITOR = "nvim";
    NVM_DIR = "${config.home.homeDirectory}/.nvm";
    TERMINFO_DIRS = lib.concatStringsSep ":" [
      "${config.home.homeDirectory}/.terminfo"
      "${config.home.profileDirectory}/share/terminfo"
      "/usr/share/terminfo"
      "/etc/terminfo"
    ];
  };

  home.file = {
    ".zshrc" = managedLink (linkSource "home/.zshrc");
    ".zshenv" = managedLink (linkSource "home/.zshenv");
    ".zprofile" = managedLink (linkSource "home/.zprofile");
    ".profile" = managedLink (linkSource "home/.profile");
    ".shellrc" = managedLink (linkSource "home/.shellrc");
    ".bash_profile" = managedLink (linkSource "home/.bash_profile");
    ".bashrc" = managedLink (linkSource "home/.bashrc");
    ".gitconfig" = managedLink (linkSource "home/.gitconfig");
    ".tmux.conf" = managedLink (linkSource "home/.tmux.conf");
    ".codex/AGENTS.md" = managedLink (linkSource "home/.codex/AGENTS.md");
    ".codex/config.toml" = managedLink (linkSource "home/.codex/config.toml");
    ".claude/CLAUDE.md" = managedLink (linkSource "home/.claude/CLAUDE.md");
    ".claude/settings.json" = managedLink (linkSource "home/.claude/settings.json");
    ".config/starship.toml" = managedLink (linkSource "config/starship.toml");
    ".config/ghostty/config" = managedLink (linkSource "config/ghostty/config");
    ".config/lazygit/config.yml" = managedLink (linkSource "config/lazygit/config.yml");
    ".config/nvim" = managedLink (linkSource "external/nvim");
  };
}
