{ config, lib, ... }:

let
  cfg = config.gruvbox.alacritty;
  p = config.gruvbox.palette;
in
{
  options.gruvbox.alacritty.enable =
    lib.mkEnableOption "gruvbox for alacritty" // { default = config.gruvbox.enable; };

  config = lib.mkIf cfg.enable {
    programs.alacritty.settings.colors = lib.mapAttrsRecursive (_: lib.mkDefault) {
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
