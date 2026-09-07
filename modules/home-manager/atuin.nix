{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.atuin;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.atuin = gl.mkModule "atuin";

  config = lib.mkIf cfg.enable {
    programs.atuin = {
      settings.theme.name = lib.mkDefault "gruvbox";
      themes.gruvbox = {
        theme.name = "gruvbox";
        colors = {
          AlertInfo = p.green;
          AlertWarn = p.yellow;
          AlertError = p.red;
          Annotation = p.gray;
          Base = p.fg;
          Guidance = p.blue;
          Important = p.accent;
          Title = p.accent;
        };
      };
    };
  };
}
