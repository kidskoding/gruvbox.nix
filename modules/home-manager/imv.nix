{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.imv;
  p = gl.paletteOf cfg;
  c = gl.noHash;
in
{
  options.gruvbox.imv = gl.mkModule "imv";

  config = lib.mkIf cfg.enable {
    programs.imv.settings.options = gl.mkDefaults {
      background = c p.bg;
      overlay_text_color = c p.fg;
      overlay_background_color = c p.bg1;
    };
  };
}
