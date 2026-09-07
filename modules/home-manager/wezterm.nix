{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.wezterm;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.wezterm = gl.mkModule "wezterm";

  config = lib.mkIf cfg.enable {
    programs.wezterm = {
      colorSchemes.gruvbox = gl.mkDefaults {
        foreground = p.fg;
        background = p.bg;
        cursor_bg = p.fg;
        cursor_fg = p.bg;
        cursor_border = p.fg;
        selection_bg = p.bg2;
        selection_fg = p.fg;
        ansi = lib.take 8 (gl.term16 p);
        brights = lib.drop 8 (gl.term16 p);
      };
      settings.color_scheme = lib.mkDefault "gruvbox";
    };
  };
}
