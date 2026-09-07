{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.gh-dash;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.gh-dash = gl.mkModule "gh-dash";

  config = lib.mkIf cfg.enable {
    programs.gh-dash.settings.theme.colors = gl.mkDefaults {
      text = {
        primary = p.fg;
        secondary = p.accent;
        inverted = p.bg;
        faint = p.fg4;
        warning = p.yellow;
        success = p.green;
        error = p.red;
      };
      background.selected = p.bg1;
      border = { primary = p.accent; secondary = p.bg2; faint = p.bg1; };
    };
  };
}
