{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.zellij;
in
{
  options.gruvbox.zellij = gl.mkModule "zellij";

  # zellij only ships gruvbox-dark and gruvbox-light, so contrast is ignored
  config = lib.mkIf cfg.enable {
    programs.zellij.settings.theme = lib.mkDefault "gruvbox-${cfg.flavor}";
  };
}
