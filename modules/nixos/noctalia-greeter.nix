{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.noctalia-greeter;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.noctalia-greeter = gl.mkModule "noctalia-greeter";

  # no-op unless noctalia-greeter's nixos module is imported
  config = lib.mkIf cfg.enable (lib.optionalAttrs (gl.hasOpt [ "programs" "noctalia-greeter" ]) {
    programs.noctalia-greeter.settings.appearance = gl.mkDefaults {
      scheme = "Synced";
      theme_mode = cfg.flavor;
      palette = {
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
