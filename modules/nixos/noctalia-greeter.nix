{ config, lib, options, ... }:

let
  cfg = config.gruvbox.noctalia-greeter;
  p = config.gruvbox.palette;
in
{
  options.gruvbox.noctalia-greeter.enable =
    lib.mkEnableOption "gruvbox for noctalia-greeter" // { default = config.gruvbox.enable; };

  # no-op unless noctalia-greeter's nixos module is imported
  config = lib.mkIf cfg.enable (lib.optionalAttrs (options.programs ? noctalia-greeter) {
    programs.noctalia-greeter.settings.appearance = {
      scheme = lib.mkDefault "Synced";
      theme_mode = lib.mkDefault config.gruvbox.flavor;
      palette = lib.mapAttrs (_: lib.mkDefault) {
        primary = p.accent;          on_primary = p.bg;
        secondary = p.purple;        on_secondary = p.bg;
        tertiary = p.green;          on_tertiary = p.bg;
        error = p.red;               on_error = p.bg;
        surface = p.bg;              on_surface = p.fg;
        surface_variant = p.bg1;     on_surface_variant = p.fg4;
        outline = p.bg2;
        shadow = p.bg0_h;
        hover = p.fg;                on_hover = p.bg;
      };
    };
  });
}
