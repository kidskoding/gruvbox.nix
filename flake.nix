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
        });
    };
}
