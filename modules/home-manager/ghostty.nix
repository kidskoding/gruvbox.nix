{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.ghostty;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.ghostty = gl.mkModule "ghostty";

  config = lib.mkIf cfg.enable {
    programs.ghostty.settings = gl.mkDefaults {
      background = p.bg;
      foreground = p.fg;
      cursor-color = p.fg;
      cursor-text = p.bg;
      selection-background = p.bg2;
      selection-foreground = p.fg;
      palette = lib.imap0 (i: c: "${toString i}=${c}") (gl.term16 p);
    };
  };
}
