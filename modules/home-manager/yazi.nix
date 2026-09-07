{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.yazi;
  p = gl.paletteOf cfg;
  on = c: { fg = p.bg; bg = c; bold = true; };
in
{
  options.gruvbox.yazi = gl.mkModule "yazi";

  config = lib.mkIf cfg.enable {
    programs.yazi.theme = gl.mkDefaults {
      mgr = {
        cwd = { fg = p.aqua; };
        hovered = { fg = p.bg; bg = p.accent; };
        preview_hovered = { underline = true; };
        find_keyword = { fg = p.yellow; italic = true; };
        find_position = { fg = p.purple; bg = "reset"; italic = true; };
        marker_copied = { fg = p.green; bg = p.green; };
        marker_cut = { fg = p.red; bg = p.red; };
        marker_marked = { fg = p.aqua; bg = p.aqua; };
        marker_selected = { fg = p.yellow; bg = p.yellow; };
        tab_active = on p.accent;
        tab_inactive = { fg = p.fg; bg = p.bg1; };
        count_copied = on p.green;
        count_cut = on p.red;
        count_selected = on p.yellow;
        border_symbol = "│";
        border_style = { fg = p.bg2; };
      };
      mode = {
        normal_main = on p.accent;
        normal_alt = { fg = p.accent; bg = p.bg1; };
        select_main = on p.green;
        select_alt = { fg = p.green; bg = p.bg1; };
        unset_main = on p.red;
        unset_alt = { fg = p.red; bg = p.bg1; };
      };
      status = {
        overall = { fg = p.fg; bg = p.bg1; };
        sep_left = { fg = p.bg1; bg = p.bg1; };
        sep_right = { fg = p.bg1; bg = p.bg1; };
        progress_label = { fg = p.fg; bold = true; };
        progress_normal = { fg = p.accent; bg = p.bg1; };
        progress_error = { fg = p.red; bg = p.bg1; };
        perm_type = { fg = p.green; };
        perm_read = { fg = p.yellow; };
        perm_write = { fg = p.red; };
        perm_exec = { fg = p.aqua; };
        perm_sep = { fg = p.fg4; };
      };
      pick = { border = { fg = p.accent; }; active = { fg = p.purple; bold = true; }; inactive = { }; };
      input = { border = { fg = p.accent; }; title = { }; value = { }; selected = { reversed = true; }; };
      cmp = { border = { fg = p.accent; }; active = { bg = p.bg1; bold = true; }; inactive = { }; };
      tasks = { border = { fg = p.accent; }; title = { }; hovered = { fg = p.purple; underline = true; }; };
      which = {
        cols = 3;
        mask = { bg = p.bg0_h; };
        cand = { fg = p.aqua; };
        rest = { fg = p.fg4; };
        desc = { fg = p.fg; };
        separator = "  ";
        separator_style = { fg = p.bg3; };
      };
      help = {
        on = { fg = p.aqua; };
        run = { fg = p.purple; };
        desc = { };
        hovered = { bg = p.bg1; bold = true; };
        footer = { fg = p.bg; bg = p.fg; };
      };
      notify = {
        title_info = { fg = p.green; };
        title_warn = { fg = p.yellow; };
        title_error = { fg = p.red; };
      };
      confirm = {
        border = { fg = p.accent; };
        title = { fg = p.accent; };
        content = { };
        list = { };
        btn_yes = { reversed = true; };
        btn_no = { };
        btn_labels = [ "  [Y]es  " "  (N)o  " ];
      };
      spot = {
        border = { fg = p.accent; };
        title = { fg = p.accent; };
        tbl_col = { fg = p.accent; };
        tbl_cell = { fg = p.yellow; reversed = true; };
      };
    };
  };
}
