{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.dunst;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.dunst = gl.mkModule "dunst";

  config = lib.mkIf cfg.enable {
    services.dunst.settings = gl.mkDefaults {
      global = {
        frame_color = p.accent;
        separator_color = "frame";
        highlight = p.accent;
      };
      urgency_low = { background = p.bg; foreground = p.fg4; frame_color = p.bg2; };
      urgency_normal = { background = p.bg; foreground = p.fg; frame_color = p.accent; };
      urgency_critical = { background = p.bg; foreground = p.fg; frame_color = p.red; };
    };
  };
}
