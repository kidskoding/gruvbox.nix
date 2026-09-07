{ config, lib, pkgs, ... }:

let
  cfg = config.gruvbox.gtk;
  dark = config.gruvbox.flavor == "dark";
  polarity = if dark then "Dark" else "Light";
in
{
  options.gruvbox.gtk.enable =
    lib.mkEnableOption "gruvbox for gtk (theme, icons, color scheme)" // { default = config.gruvbox.enable; };

  config = lib.mkIf cfg.enable {
    gtk = {
      enable = lib.mkDefault true;
      colorScheme = lib.mkDefault config.gruvbox.flavor;
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
