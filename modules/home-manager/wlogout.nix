{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.wlogout;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.wlogout = gl.mkModule "wlogout";

  # use @gruvbox_<key> in your own css
  config = lib.mkIf cfg.enable {
    programs.wlogout.style = lib.mkBefore
      (lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "@define-color gruvbox_${k} ${v};") p));
  };
}
