{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.bottom;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.bottom = gl.mkModule "bottom";

  config = lib.mkIf cfg.enable {
    programs.bottom.settings.styles.colors = gl.mkDefaults {
      table_header_color = p.accent;
      all_cpu_color = p.fg;
      avg_cpu_color = p.orange;
      cpu_core_colors = [ p.red p.green p.yellow p.blue p.purple p.aqua p.orange ];
      ram_color = p.purple;
      swap_color = p.red;
      rx_color = p.green;
      tx_color = p.red;
      widget_title_color = p.fg;
      border_color = p.bg2;
      highlighted_border_color = p.accent;
      text_color = p.fg;
      graph_color = p.fg4;
      cursor_color = p.accent;
      selected_text_color = p.bg;
      selected_bg_color = p.accent;
      high_battery_color = p.green;
      medium_battery_color = p.yellow;
      low_battery_color = p.red;
    };
  };
}
