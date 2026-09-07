{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.console;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.console = gl.mkModule "console (tty)";

  config = lib.mkIf cfg.enable (lib.optionalAttrs (gl.hasOpt [ "console" "colors" ]) {
    console.colors = lib.mkDefault (map gl.noHash (gl.term16 p));
  });
}
