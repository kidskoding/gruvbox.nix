{ config, lib, ... }:

let
  gl = import ../lib;
  cfg = config.gruvbox;
  colors = lib.types.attrsOf lib.types.str;
in
{
  options.gruvbox = {
    enable = lib.mkEnableOption "gruvbox theming";

    flavor = lib.mkOption {
      type = lib.types.enum [ "dark" "light" ];
      default = "dark";
      description = "dark or light gruvbox.";
    };

    contrast = lib.mkOption {
      type = lib.types.enum [ "hard" "medium" "soft" ];
      default = "medium";
      description = "background contrast: picks bg0_h, bg0 or bg0_s as `bg`.";
    };

    accent = lib.mkOption {
      type = lib.types.enum [ "red" "green" "yellow" "blue" "purple" "aqua" "orange" ];
      default = "orange";
      description = "highlight color used for borders, primary ui slots, prompts.";
    };

    palette = lib.mkOption {
      type = colors;
      readOnly = true;
      default = gl.palette { inherit (cfg) flavor contrast accent; };
      description = ''
        full gruvbox table as `#rrggbb` strings: bg0_h bg0 bg0_s bg1..bg4, fg0..fg4, gray,
        bright colors (red green yellow blue purple aqua orange), neutral* colors,
        plus derived `bg` (by contrast), `fg` (fg1) and `accent`.
      '';
    };

    rgb = lib.mkOption {
      type = colors;
      readOnly = true;
      default = lib.mapAttrs (_: gl.hexToRgb ", ") cfg.palette;
      description = "palette as \"R, G, B\" strings for css rgba().";
    };

    ansi = lib.mkOption {
      type = colors;
      readOnly = true;
      default = lib.mapAttrs (_: gl.hexToRgb ";") cfg.palette;
      description = "palette as \"R;G;B\" strings for truecolor escapes (38;2;R;G;B).";
    };
  };
}
