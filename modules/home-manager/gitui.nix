{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.gitui;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.gitui = gl.mkModule "gitui";

  config = lib.mkIf cfg.enable {
    programs.gitui.theme = lib.mkDefault ''
      (
        selected_tab: Some("Reset"),
        command_fg: Some("${p.fg}"),
        selection_bg: Some("${p.bg2}"),
        selection_fg: Some("${p.fg}"),
        cmdbar_bg: Some("${p.bg1}"),
        cmdbar_extra_lines_bg: Some("${p.bg1}"),
        disabled_fg: Some("${p.gray}"),
        diff_line_add: Some("${p.green}"),
        diff_line_delete: Some("${p.red}"),
        diff_file_added: Some("${p.green}"),
        diff_file_removed: Some("${p.red}"),
        diff_file_moved: Some("${p.purple}"),
        diff_file_modified: Some("${p.orange}"),
        commit_hash: Some("${p.purple}"),
        commit_time: Some("${p.blue}"),
        commit_author: Some("${p.aqua}"),
        danger_fg: Some("${p.red}"),
        push_gauge_bg: Some("${p.accent}"),
        push_gauge_fg: Some("${p.bg}"),
        tag_fg: Some("${p.yellow}"),
        branch_fg: Some("${p.aqua}"),
      )
    '';
  };
}
