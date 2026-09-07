{ config, lib, options, pkgs, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.gtk;
  dark = cfg.flavor == "dark";
  polarity = if dark then "Dark" else "Light";
in
{
  options.gruvbox.gtk = gl.mkModule "gtk";

  config = lib.mkIf cfg.enable {
    gtk = {
      enable = lib.mkDefault true;
      colorScheme = lib.mkDefault cfg.flavor;
      theme = {
        name = lib.mkDefault "Gruvbox-${polarity}";
        package = lib.mkDefault pkgs.gruvbox-gtk-theme;
      };
      iconTheme = {
        name = lib.mkDefault "Gruvbox-Plus-${polarity}";
        package = lib.mkDefault pkgs.gruvbox-plus-icons;
      };
    };

    # portals and libadwaita apps read this, not settings.ini
    dconf.settings."org/gnome/desktop/interface".color-scheme =
      lib.mkDefault (if dark then "prefer-dark" else "default");
  };
}
