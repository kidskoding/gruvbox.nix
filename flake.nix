{
  description = "gruvbox for nixos and home-manager: one switch, every app";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # only used by checks
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAll = nixpkgs.lib.genAttrs systems;
    in
    {
      homeModules.default = ./modules/home-manager;
      nixosModules.default = ./modules/nixos;
      lib = import ./lib;

      checks = forAll (system:
        let pkgs = nixpkgs.legacyPackages.${system}; in
        {
          palette = pkgs.runCommand "gruvbox-palette-check" { } ''
            echo ${import ./lib/test.nix} > $out
          '';

          # niri and noctalia modules are no-ops here: their option trees are not imported
          hm = (home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
              self.homeModules.default
              ({ config, lib, ... }: {
                home.username = "check";
                home.homeDirectory = "/home/check";
                home.stateVersion = "25.05";
                gruvbox.enable = true;
                gruvbox.contrast = "hard";
                gruvbox.accent = "yellow";
              })
            ];
          }).activationPackage;

          # eval only: building a toplevel would pull a whole system closure
          nixos =
            let
              cfg = (nixpkgs.lib.nixosSystem {
                inherit system;
                modules = [
                  self.nixosModules.default
                  {
                    gruvbox.enable = true;
                    gruvbox.accent = "aqua";
                    boot.loader.grub.enable = false;
                    fileSystems."/".device = "/dev/null";
                    system.stateVersion = "25.05";
                  }
                ];
              }).config;
            in
            assert cfg.gruvbox.palette.accent == "#8ec07c";
            pkgs.runCommand "gruvbox-nixos-check" { } "echo '${cfg.gruvbox.palette.accent}' > $out";
        });
    };
}
