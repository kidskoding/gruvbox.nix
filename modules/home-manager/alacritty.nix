{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.alacritty;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.alacritty = gl.mkModule "alacritty";

  config = lib.mkIf cfg.enable {
    programs.alacritty.settings.colors = gl.mkDefaults {
      primary = { background = p.bg; foreground = p.fg; };
      normal = {
        black = p.bg; red = p.neutralRed; green = p.neutralGreen; yellow = p.neutralYellow;
        blue = p.neutralBlue; magenta = p.neutralPurple; cyan = p.neutralAqua; white = p.fg4;
      };
      bright = {
        black = p.gray; red = p.red; green = p.green; yellow = p.yellow;
        blue = p.blue; magenta = p.purple; cyan = p.aqua; white = p.fg;
      };
    };
  };
}
