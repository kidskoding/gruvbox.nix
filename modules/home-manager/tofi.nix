{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.tofi;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.tofi = gl.mkModule "tofi";

  config = lib.mkIf cfg.enable {
    programs.tofi.settings = gl.mkDefaults {
      background-color = p.bg;
      text-color = p.fg;
      prompt-color = p.accent;
      placeholder-color = p.fg4;
      input-color = p.fg;
      default-result-color = p.fg;
      selection-color = p.accent;
      selection-match-color = p.yellow;
      selection-background = p.bg1;
      border-color = p.accent;
      outline-color = p.bg;
    };
  };
}
