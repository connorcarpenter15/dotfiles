{
  description = "Connor's cross-platform dotfiles";

  nixConfig.extra-experimental-features = [
    "nix-command"
    "flakes"
  ];

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      lib = nixpkgs.lib;

      supportedSystems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];

      forAllSystems = f: lib.genAttrs supportedSystems (system: f system);

      envOr =
        name: fallback:
        let
          value = builtins.getEnv name;
        in
        if value != "" then value else fallback;

      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

      mkHomeConfiguration =
        system:
        let
          pkgs = mkPkgs system;
          defaultHome = if pkgs.stdenv.isDarwin then "/Users/dotfiles" else "/home/dotfiles";
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = {
            inherit inputs;
            dotfilesPath = envOr "DOTFILES_DIR" self.outPath;
          };

          modules = [
            ./nix/home.nix
            {
              home.username = envOr "USER" "dotfiles";
              home.homeDirectory = envOr "HOME" defaultHome;
            }
          ];
        };
    in
    {
      homeConfigurations = forAllSystems mkHomeConfiguration;

      apps = forAllSystems (system: {
        home-manager = {
          type = "app";
          program = "${home-manager.packages.${system}.home-manager}/bin/home-manager";
          meta.description = "Run Home Manager from this dotfiles flake";
        };
      });

      packages = forAllSystems (system: {
        default = home-manager.packages.${system}.home-manager;
        home-manager = home-manager.packages.${system}.home-manager;
      });

      formatter = forAllSystems (system: (mkPkgs system).nixfmt);
    };
}
