{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.foot;
  p = gl.paletteOf cfg;
  # foot wants rrggbb without #
  c = gl.noHash;
in
{
  options.gruvbox.foot = gl.mkModule "foot";

  config = lib.mkIf cfg.enable {
    programs.foot.settings.colors = gl.mkDefaults ({
      background = c p.bg;
      foreground = c p.fg;
      selection-background = c p.bg2;
      selection-foreground = c p.fg;
      urls = c p.blue;
    } // lib.listToAttrs (lib.imap0
      (i: col: lib.nameValuePair (if i < 8 then "regular${toString i}" else "bright${toString (i - 8)}") (c col))
      (gl.term16 p)));
  };
}
