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
                programs.alacritty.enable = true;
                programs.zellij.enable = true;
                programs.fish.enable = true;
                programs.dircolors.enable = true;
                programs.fastfetch.enable = true;
                programs.starship.enable = true;
                assertions = [
                  {
                    assertion = config.programs.alacritty.settings.colors.primary.background == "#1d2021";
                    message = "alacritty bg should follow contrast=hard";
                  }
                  {
                    assertion = config.programs.zellij.settings.theme == "gruvbox-dark";
                    message = "zellij theme name";
                  }
                  {
                    assertion = config.programs.starship.settings.palettes.gruvbox."bright-yellow" == "#fabd2f";
                    message = "starship palette";
                  }
                ];
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
