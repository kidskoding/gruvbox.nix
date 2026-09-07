{ config, lib, pkgs, ... }:

let
  cfg = config.gruvbox.qt;
  dark = config.gruvbox.flavor == "dark";
in
{
  options.gruvbox.qt.enable =
    lib.mkEnableOption "gruvbox for qt (kvantum on dark, gtk platform theme on light)" // { default = config.gruvbox.enable; };

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
