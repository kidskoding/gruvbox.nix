{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.polybar;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.polybar = gl.mkModule "polybar";

  # use ${colors.<key>} in your own bars
  config = lib.mkIf cfg.enable {
    services.polybar.settings.colors = gl.mkDefaults p;
  };
}
