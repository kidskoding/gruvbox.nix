{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.btop;
in
{
  options.gruvbox.btop = gl.mkModule "btop";

  # btop ships gruvbox_dark and gruvbox_light; contrast is ignored
  config = lib.mkIf cfg.enable {
    programs.btop.settings.color_theme = lib.mkDefault "gruvbox_${cfg.flavor}";
  };
}
