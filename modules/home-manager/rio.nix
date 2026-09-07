{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.rio;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.rio = gl.mkModule "rio";

  config = lib.mkIf cfg.enable {
    programs.rio.settings.colors = gl.mkDefaults {
      background = p.bg;
      foreground = p.fg;
      cursor = p.fg;
      selection-background = p.bg2;
      selection-foreground = p.fg;
      tabs = p.bg1;
      tabs-active = p.accent;
      black = p.bg; red = p.neutralRed; green = p.neutralGreen; yellow = p.neutralYellow;
      blue = p.neutralBlue; magenta = p.neutralPurple; cyan = p.neutralAqua; white = p.fg4;
      light-black = p.gray; light-red = p.red; light-green = p.green; light-yellow = p.yellow;
      light-blue = p.blue; light-magenta = p.purple; light-cyan = p.aqua; light-white = p.fg;
    };
  };
}
