{ config, lib, options, pkgs, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.qt;
  dark = cfg.flavor == "dark";
in
{
  options.gruvbox.qt = gl.mkModule "qt";

  # nixpkgs has no light kvantum theme, so light follows gtk instead
  config = lib.mkIf cfg.enable (lib.mkMerge [
    { qt.enable = lib.mkDefault true; }
    (lib.mkIf dark {
      qt.platformTheme.name = lib.mkDefault "qtct";
      qt.style.name = lib.mkDefault "kvantum";
      qt.kvantum = {
        enable = lib.mkDefault true;
        themes = [ pkgs.gruvbox-kvantum ];
        settings.General.theme = lib.mkDefault "Gruvbox-Dark-Brown";
      };
    })
    (lib.mkIf (!dark) {
      qt.platformTheme.name = lib.mkDefault "gtk";
    })
  ]);
}
