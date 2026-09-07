{ config, lib, ... }:

let
  cfg = config.gruvbox.starship;
  p = config.gruvbox.palette;
in
{
  options.gruvbox.starship.enable =
    lib.mkEnableOption "gruvbox for starship" // { default = config.gruvbox.enable; };

  # style names like "bold yellow" resolve through this palette
  config = lib.mkIf cfg.enable {
    programs.starship.settings = {
      palette = lib.mkDefault "gruvbox";
      palettes.gruvbox = lib.mapAttrs (_: lib.mkDefault) {
        black = p.bg; red = p.neutralRed; green = p.neutralGreen; yellow = p.neutralYellow;
        blue = p.neutralBlue; purple = p.neutralPurple; cyan = p.neutralAqua; white = p.fg4;
        "bright-black" = p.gray; "bright-red" = p.red; "bright-green" = p.green; "bright-yellow" = p.yellow;
        "bright-blue" = p.blue; "bright-purple" = p.purple; "bright-cyan" = p.aqua; "bright-white" = p.fg;
        orange = p.orange; gray = p.gray; bg = p.bg; fg = p.fg; accent = p.accent;
      };
    };
  };
}
