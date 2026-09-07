{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.fuzzel;
  p = gl.paletteOf cfg;
  # fuzzel wants rrggbbaa
  c = h: "${gl.noHash h}ff";
in
{
  options.gruvbox.fuzzel = gl.mkModule "fuzzel";

  config = lib.mkIf cfg.enable {
    programs.fuzzel.settings.colors = gl.mkDefaults {
      background = c p.bg;
      text = c p.fg;
      prompt = c p.fg;
      placeholder = c p.fg4;
      input = c p.fg;
      match = c p.accent;
      selection = c p.bg1;
      selection-text = c p.fg;
      selection-match = c p.accent;
      counter = c p.fg4;
      border = c p.accent;
    };
  };
}
