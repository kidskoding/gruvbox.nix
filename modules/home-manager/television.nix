{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.television;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.television = gl.mkModule "television";

  config = lib.mkIf cfg.enable {
    programs.television = {
      settings.ui.theme = lib.mkDefault "gruvbox";
      themes.gruvbox = {
        background = p.bg;
        border_fg = p.bg2;
        text_fg = p.fg;
        dimmed_text_fg = p.fg4;
        input_text_fg = p.fg;
        result_count_fg = p.accent;
        result_name_fg = p.blue;
        result_line_number_fg = p.yellow;
        result_value_fg = p.fg;
        selection_bg = p.bg1;
        selection_fg = p.fg;
        match_fg = p.accent;
        preview_title_fg = p.purple;
        channel_name_fg = p.accent;
        channel_mode_fg = p.bg;
        channel_mode_bg = p.accent;
      };
    };
  };
}
