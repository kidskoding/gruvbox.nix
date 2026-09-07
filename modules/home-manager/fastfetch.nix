{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.fastfetch;
  a = gl.ansiOf cfg;
in
{
  options.gruvbox.fastfetch = gl.mkModule "fastfetch";

  config = lib.mkIf cfg.enable {
    programs.fastfetch.settings.display.color = gl.mkDefaults {
      keys = gl.fg a.accent;
      title = gl.fg a.accent;
      separator = gl.fg a.gray;
    };
  };
}
