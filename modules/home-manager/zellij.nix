{ config, lib, ... }:

let
  cfg = config.gruvbox.zellij;
in
{
  options.gruvbox.zellij.enable =
    lib.mkEnableOption "gruvbox for zellij" // { default = config.gruvbox.enable; };

  # zellij only ships gruvbox-dark and gruvbox-light, so contrast is ignored
  config = lib.mkIf cfg.enable {
    programs.zellij.settings.theme = lib.mkDefault "gruvbox-${config.gruvbox.flavor}";
  };
}
