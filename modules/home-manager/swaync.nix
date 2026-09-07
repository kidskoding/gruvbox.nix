{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.swaync;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.swaync = gl.mkModule "swaync";

  # use @gruvbox_<key> in your own css
  config = lib.mkIf cfg.enable {
    services.swaync.style = lib.mkBefore
      (lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "@define-color gruvbox_${k} ${v};") p));
  };
}
