{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.vivid;
in
{
  options.gruvbox.vivid = gl.mkModule "vivid";

  # vivid ships all six gruvbox variants
  config = lib.mkIf cfg.enable {
    programs.vivid.activeTheme = lib.mkDefault
      ("gruvbox-${cfg.flavor}" + lib.optionalString (cfg.contrast != "medium") "-${cfg.contrast}");
  };
}
