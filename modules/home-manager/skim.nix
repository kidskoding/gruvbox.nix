{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.skim;
  p = gl.paletteOf cfg;
  colors = {
    fg = p.fg; bg = p.bg; matched = p.accent; matched_bg = p.bg;
    current = p.fg; current_bg = p.bg1; current_match = p.accent; current_match_bg = p.bg1;
    spinner = p.purple; info = p.blue; prompt = p.accent; cursor = p.accent;
    selected = p.green; header = p.gray; border = p.bg2;
  };
in
{
  options.gruvbox.skim = gl.mkModule "skim";

  config = lib.mkIf cfg.enable {
    programs.skim.defaultOptions = [
      "--color=${lib.concatStringsSep "," (lib.mapAttrsToList (k: v: "${k}:${v}") colors)}"
    ];
  };
}
