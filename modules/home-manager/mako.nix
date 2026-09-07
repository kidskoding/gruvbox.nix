{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.mako;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.mako = gl.mkModule "mako";

  config = lib.mkIf cfg.enable {
    services.mako.settings = gl.mkDefaults {
      background-color = p.bg;
      text-color = p.fg;
      border-color = p.accent;
      progress-color = "over ${p.bg2}";
      "urgency=low" = { border-color = p.bg2; text-color = p.fg4; };
      "urgency=high" = { border-color = p.red; };
    };
  };
}
