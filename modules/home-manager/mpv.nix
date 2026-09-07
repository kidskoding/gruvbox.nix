{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.mpv;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.mpv = gl.mkModule "mpv";

  config = lib.mkIf cfg.enable {
    programs.mpv.config = gl.mkDefaults {
      osd-color = p.fg;
      osd-back-color = p.bg;
      osd-border-color = p.bg0_h;
      osd-shadow-color = p.bg0_h;
      sub-color = p.fg;
      sub-border-color = p.bg0_h;
    };
  };
}
