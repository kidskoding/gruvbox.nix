{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.hyprlock;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.hyprlock = gl.mkModule "hyprlock";

  # hyprlock elements are lists your config owns, so only $gruvbox_<key> variables are set
  config = lib.mkIf cfg.enable {
    programs.hyprlock.settings =
      lib.mapAttrs' (k: v: lib.nameValuePair "$gruvbox_${k}" (lib.mkDefault "rgb(${gl.noHash v})")) p;
  };
}
