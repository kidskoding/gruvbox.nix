{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.bat;
in
{
  options.gruvbox.bat = gl.mkModule "bat";

  # bat ships gruvbox-dark and gruvbox-light; contrast is ignored
  config = lib.mkIf cfg.enable {
    programs.bat.config.theme = lib.mkDefault "gruvbox-${cfg.flavor}";
  };
}
