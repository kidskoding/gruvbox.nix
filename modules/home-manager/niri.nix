{ config, lib, options, ... }:

let
  cfg = config.gruvbox.niri;
  p = config.gruvbox.palette;
in
{
  options.gruvbox.niri.enable =
    lib.mkEnableOption "gruvbox for niri (background, borders, shadow)" // { default = config.gruvbox.enable; };

  # no-op unless niri-flake's home-manager module is imported
  config = lib.mkIf cfg.enable (lib.optionalAttrs (options.programs ? niri) {
    programs.niri.settings.layout = {
      background-color = lib.mkDefault p.bg;
      border.active.color = lib.mkDefault p.accent;
      border.inactive.color = lib.mkDefault p.bg1;
      shadow.color = lib.mkDefault "${p.bg0_h}ee";
    };
  });
}
