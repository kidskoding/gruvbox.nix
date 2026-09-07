{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.fzf;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.fzf = gl.mkModule "fzf";

  config = lib.mkIf cfg.enable {
    programs.fzf.colors = gl.mkDefaults {
      fg = p.fg;
      bg = p.bg;
      hl = p.accent;
      "fg+" = p.fg;
      "bg+" = p.bg1;
      "hl+" = p.accent;
      info = p.blue;
      prompt = p.accent;
      pointer = p.accent;
      marker = p.green;
      spinner = p.purple;
      header = p.gray;
      border = p.bg2;
    };
  };
}
