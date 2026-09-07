{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.opencode;
in
{
  options.gruvbox.opencode = gl.mkModule "opencode";

  # opencode ships a gruvbox theme
  config = lib.mkIf cfg.enable {
    programs.opencode.settings.theme = lib.mkDefault "gruvbox";
  };
}
