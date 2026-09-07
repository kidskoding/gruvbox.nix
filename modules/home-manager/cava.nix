{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.cava;
  p = gl.paletteOf cfg;
  # cava needs colors quoted inside its ini
  q = c: "'${c}'";
in
{
  options.gruvbox.cava = gl.mkModule "cava";

  config = lib.mkIf cfg.enable {
    programs.cava.settings.color = gl.mkDefaults {
      gradient = 1;
      gradient_color_1 = q p.green;
      gradient_color_2 = q p.yellow;
      gradient_color_3 = q p.orange;
      gradient_color_4 = q p.red;
      gradient_color_5 = q p.purple;
      gradient_color_6 = q p.blue;
      gradient_color_7 = q p.aqua;
    };
  };
}
