{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.micro;
in
{
  options.gruvbox.micro = gl.mkModule "micro";

  # micro ships gruvbox-tc (truecolor); dark only
  config = lib.mkIf cfg.enable {
    programs.micro.settings.colorscheme = lib.mkDefault "gruvbox-tc";
  };
}
