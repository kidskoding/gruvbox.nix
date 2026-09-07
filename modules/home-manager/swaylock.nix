{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.swaylock;
  p = gl.paletteOf cfg;
  c = gl.noHash;
in
{
  options.gruvbox.swaylock = gl.mkModule "swaylock";

  config = lib.mkIf cfg.enable {
    programs.swaylock.settings = gl.mkDefaults {
      color = c p.bg;
      inside-color = c p.bg;
      ring-color = c p.accent;
      line-color = c p.bg;
      separator-color = c p.bg;
      text-color = c p.fg;
      key-hl-color = c p.green;
      bs-hl-color = c p.red;
      caps-lock-key-hl-color = c p.yellow;
      caps-lock-bs-hl-color = c p.red;
      inside-clear-color = c p.bg1;
      ring-clear-color = c p.yellow;
      text-clear-color = c p.fg;
      inside-ver-color = c p.bg1;
      ring-ver-color = c p.blue;
      text-ver-color = c p.fg;
      inside-wrong-color = c p.bg1;
      ring-wrong-color = c p.red;
      text-wrong-color = c p.fg;
    };
  };
}
