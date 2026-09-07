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
        let
          pkgs = nixpkgs.legacyPackages.${system};
          lib = nixpkgs.lib;

          hm = (home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [ self.homeModules.default ./checks/hm.nix ];
          }).config;

          nixos = (lib.evalModules {
            modules = [ self.nixosModules.default { gruvbox.enable = true; gruvbox.accent = "aqua"; } ];
          }).config;

          # [ actual expected ] pairs; reading them forces every module's options
          expect = with hm; [
            [ programs.alacritty.settings.colors.primary.background "#1d2021" ]
            [ programs.alacritty.settings.colors.bright.cyan "#8ec07c" ]
            [ programs.zellij.settings.theme "gruvbox-light" ]
            [ (lib.hasInfix "set -g fish_color_command b8bb26" programs.fish.interactiveShellInit) true ]
            [ programs.dircolors.settings.DIR "1;38;2;131;165;152" ]
            [ (lib.hasInfix "lp=38;2;142;192;124" home.sessionVariables.EZA_COLORS) true ]
            [ programs.fastfetch.settings.display.color.keys "38;2;250;189;47" ]
            [ programs.starship.settings.palettes.gruvbox."bright-yellow" "#fabd2f" ]
            [ gtk.theme.name "Gruvbox-Dark" ]
            [ gtk.iconTheme.name "Gruvbox-Plus-Dark" ]
            [ qt.kvantum.settings.General.theme "Gruvbox-Dark-Brown" ]
            [ (lib.hasInfix "gruvbox-dark-hard" xdg.configFile."doom/gruvbox.el".text) true ]
            [ programs.kitty.settings.background "#1d2021" ]
            [ programs.kitty.settings.active_border_color "#d3869b" ]
            [ programs.foot.settings.colors.background "1d2021" ]
            [ programs.foot.settings.colors.bright1 "fb4934" ]
            [ (builtins.head programs.ghostty.settings.background) "#1d2021" ]
            [ (builtins.head programs.ghostty.settings.palette) "0=#1d2021" ]
            [ programs.wezterm.settings.color_scheme "gruvbox" ]
            [ (builtins.head programs.wezterm.colorSchemes.gruvbox.brights) "#928374" ]
            [ nixos.gruvbox.palette.accent "#8ec07c" ]
          ];
          bad = builtins.filter (e: builtins.elemAt e 0 != builtins.elemAt e 1) expect;
        in
        {
          palette = pkgs.runCommand "gruvbox-palette-check" { } ''
            echo ${import ./lib/test.nix} > $out
          '';

          # eval only: nothing is built, so adding modules never slows ci down
          modules =
            assert bad == [ ] || throw "gruvbox modules check failed: ${builtins.toJSON bad}";
            pkgs.writeText "gruvbox-modules-check" (builtins.toJSON (map builtins.head expect));
        });
    };
}
