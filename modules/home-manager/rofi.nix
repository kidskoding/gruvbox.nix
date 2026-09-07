{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.rofi;
  p = gl.paletteOf cfg;
  inherit (config.lib.formats.rasi) mkLiteral;
  section = lib.mapAttrs (_: v: lib.mkDefault (mkLiteral v));
in
{
  options.gruvbox.rofi = gl.mkModule "rofi";

  config = lib.mkIf cfg.enable {
    programs.rofi.theme = lib.mapAttrs (_: section) {
      "*" = {
        background-color = p.bg;
        text-color = p.fg;
        border-color = p.accent;
        separatorcolor = p.bg2;
      };
      "element selected normal" = { background-color = p.accent; text-color = p.bg; };
      "element selected active" = { background-color = p.accent; text-color = p.bg; };
      "element normal active" = { text-color = p.accent; };
      "element normal urgent" = { text-color = p.red; };
      "element selected urgent" = { background-color = p.red; text-color = p.bg; };
      "element alternate normal" = { background-color = p.bg; };
    };
  };
}
