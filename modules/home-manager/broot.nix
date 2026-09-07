{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.broot;
  p = gl.paletteOf cfg;
  rgb = h: "rgb(${gl.hexToRgb "," h})";
  fg = h: "${rgb h} None";
  fgbg = f: b: "${rgb f} ${rgb b}";
in
{
  options.gruvbox.broot = gl.mkModule "broot";

  config = lib.mkIf cfg.enable {
    programs.broot.settings.skin = gl.mkDefaults {
      default = fgbg p.fg p.bg;
      tree = fg p.bg3;
      parent = fg p.fg4;
      file = fg p.fg;
      directory = "${rgb p.blue} None Bold";
      exe = fg p.green;
      link = fg p.aqua;
      pruning = "${rgb p.gray} None Italic";
      perm__ = fg p.bg3;
      perm_r = fg p.yellow;
      perm_w = fg p.red;
      perm_x = fg p.green;
      owner = fg p.fg4;
      group = fg p.fg4;
      count = fg p.fg4;
      dates = fg p.fg4;
      sparse = fg p.yellow;
      git_branch = fg p.fg;
      git_insertions = fg p.green;
      git_deletions = fg p.red;
      git_status_current = fg p.fg;
      git_status_modified = fg p.yellow;
      git_status_new = "${rgb p.green} None Bold";
      git_status_ignored = fg p.gray;
      git_status_conflicted = fg p.red;
      git_status_other = fg p.red;
      selected_line = "None ${rgb p.bg1}";
      char_match = "${rgb p.accent} None Bold";
      file_error = fg p.red;
      flag_label = fg p.fg4;
      flag_value = "${rgb p.accent} None Bold";
      input = fg p.fg;
      status_error = fgbg p.red p.bg1;
      status_job = "${rgb p.yellow} ${rgb p.bg1} Bold";
      status_normal = "None ${rgb p.bg1}";
      status_italic = "${rgb p.accent} ${rgb p.bg1} Italic";
      status_bold = "${rgb p.fg} ${rgb p.bg1} Bold";
      status_code = fgbg p.purple p.bg1;
      status_ellipsis = fgbg p.fg p.bg1;
      purpose_normal = "None None";
      purpose_italic = "${rgb p.accent} None Italic";
      purpose_bold = "${rgb p.fg} None Bold";
      purpose_ellipsis = "None None";
      scrollbar_track = fg p.bg1;
      scrollbar_thumb = fg p.bg3;
      help_paragraph = fg p.fg;
      help_bold = "${rgb p.accent} None Bold";
      help_italic = "${rgb p.purple} None Italic";
      help_code = fgbg p.fg p.bg1;
      help_headers = "${rgb p.accent} None Bold";
      help_table_border = fg p.bg2;
      preview_title = fgbg p.fg p.bg1;
      preview = fgbg p.fg p.bg;
      preview_line_number = fgbg p.fg4 p.bg;
      preview_match = "None ${rgb p.bg2} Bold";
      hex_null = fg p.bg3;
      hex_ascii_graphic = fg p.fg;
      hex_ascii_whitespace = fg p.fg4;
      hex_ascii_other = fg p.yellow;
      hex_non_ascii = fg p.purple;
      staging_area_title = fgbg p.fg p.bg1;
      mode_command_mark = "${rgb p.bg} ${rgb p.accent} Bold";
      good_to_bad_0 = fg p.green;
      good_to_bad_1 = fg p.green;
      good_to_bad_2 = fg p.yellow;
      good_to_bad_3 = fg p.yellow;
      good_to_bad_4 = fg p.orange;
      good_to_bad_5 = fg p.orange;
      good_to_bad_6 = fg p.red;
      good_to_bad_7 = fg p.red;
      good_to_bad_8 = fg p.red;
      good_to_bad_9 = fg p.red;
    };
  };
}
