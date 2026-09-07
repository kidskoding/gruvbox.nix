{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.sway;
  p = gl.paletteOf cfg;
  set = border: background: text: { inherit border background text; indicator = border; childBorder = border; };
in
{
  options.gruvbox.sway = gl.mkModule "sway";

  config = lib.mkIf cfg.enable {
    wayland.windowManager.sway.config.colors = gl.mkDefaults {
      background = p.bg;
      focused = set p.accent p.accent p.bg;
      focusedInactive = set p.bg2 p.bg1 p.fg;
      unfocused = set p.bg1 p.bg p.fg4;
      urgent = set p.red p.red p.bg;
      placeholder = set p.bg p.bg p.fg4;
    };
  };
}
