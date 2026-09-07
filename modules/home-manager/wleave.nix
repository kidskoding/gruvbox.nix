{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.wleave;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.wleave = gl.mkModule "wleave";

  # use @gruvbox_<key> in your own css
  config = lib.mkIf cfg.enable {
    programs.wleave.style = lib.mkBefore
      (lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "@define-color gruvbox_${k} ${v};") p));
  };
}
