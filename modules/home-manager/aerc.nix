{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.aerc;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.aerc = gl.mkModule "aerc";

  config = lib.mkIf cfg.enable {
    programs.aerc = {
      extraConfig.ui.styleset-name = lib.mkDefault "gruvbox";
      stylesets.gruvbox = ''
        *.default = true
        *.selected.fg = ${p.bg}
        *.selected.bg = ${p.accent}
        default.fg = ${p.fg}
        default.bg = ${p.bg}
        error.fg = ${p.red}
        warning.fg = ${p.yellow}
        success.fg = ${p.green}
        title.fg = ${p.accent}
        title.bold = true
        header.fg = ${p.blue}
        statusline_default.fg = ${p.fg}
        statusline_default.bg = ${p.bg1}
        statusline_error.fg = ${p.red}
        statusline_success.fg = ${p.green}
        msglist_unread.bold = true
        msglist_flagged.fg = ${p.yellow}
        msglist_deleted.fg = ${p.gray}
        msglist_marked.bg = ${p.bg2}
        msglist_result.fg = ${p.green}
        dirlist_unread.bold = true
        dirlist_recent.fg = ${p.aqua}
        completion_pager.bg = ${p.bg1}
        selector_focused.fg = ${p.bg}
        selector_focused.bg = ${p.accent}
        selector_chooser.bold = true
        tab.bg = ${p.bg1}
        tab.selected.fg = ${p.bg}
        tab.selected.bg = ${p.accent}
        border.fg = ${p.bg2}
        spinner.fg = ${p.accent}
      '';
    };
  };
}
