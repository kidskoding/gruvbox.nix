{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.kitty;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.kitty = gl.mkModule "kitty";

  config = lib.mkIf cfg.enable {
    programs.kitty.settings = gl.mkDefaults ({
      background = p.bg;
      foreground = p.fg;
      cursor = p.fg;
      cursor_text_color = p.bg;
      selection_background = p.bg2;
      selection_foreground = p.fg;
      url_color = p.blue;
      active_border_color = p.accent;
      inactive_border_color = p.bg2;
      active_tab_background = p.accent;
      active_tab_foreground = p.bg;
      inactive_tab_background = p.bg1;
      inactive_tab_foreground = p.fg4;
    } // lib.listToAttrs (lib.imap0 (i: c: lib.nameValuePair "color${toString i}" c) (gl.term16 p)));
  };
}
