{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.tmux;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.tmux = gl.mkModule "tmux";

  # mkBefore so lines in your own extraConfig win, tmux keeps the last set
  config = lib.mkIf cfg.enable {
    programs.tmux.extraConfig = lib.mkBefore ''
      set -g status-style "bg=${p.bg1},fg=${p.fg}"
      set -g window-status-current-style "bg=${p.accent},fg=${p.bg}"
      set -g pane-border-style "fg=${p.bg2}"
      set -g pane-active-border-style "fg=${p.accent}"
      set -g message-style "bg=${p.bg1},fg=${p.fg}"
      set -g mode-style "bg=${p.bg2},fg=${p.fg}"
      set -g clock-mode-colour "${p.accent}"
    '';
  };
}
