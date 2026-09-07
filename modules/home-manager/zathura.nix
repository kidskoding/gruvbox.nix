{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.zathura;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.zathura = gl.mkModule "zathura";

  config = lib.mkIf cfg.enable {
    programs.zathura.options = gl.mkDefaults {
      default-bg = p.bg;
      default-fg = p.fg;
      statusbar-bg = p.bg1;
      statusbar-fg = p.fg;
      inputbar-bg = p.bg;
      inputbar-fg = p.fg;
      notification-bg = p.bg;
      notification-fg = p.fg;
      notification-error-bg = p.red;
      notification-error-fg = p.bg;
      notification-warning-bg = p.yellow;
      notification-warning-fg = p.bg;
      highlight-color = p.accent;
      highlight-active-color = p.blue;
      completion-bg = p.bg1;
      completion-fg = p.fg;
      completion-group-bg = p.bg1;
      completion-group-fg = p.fg4;
      completion-highlight-bg = p.accent;
      completion-highlight-fg = p.bg;
      index-bg = p.bg;
      index-fg = p.fg;
      index-active-bg = p.accent;
      index-active-fg = p.bg;
      render-loading-bg = p.bg;
      render-loading-fg = p.fg;
      recolor-lightcolor = p.bg;
      recolor-darkcolor = p.fg;
    };
  };
}
