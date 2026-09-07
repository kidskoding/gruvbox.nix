{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.sioyek;
  p = gl.paletteOf cfg;
  # sioyek takes colors as "r g b" floats in 0..1
  f = hex: lib.concatMapStringsSep " " (n: toString (lib.toInt n / 255.0)) (lib.splitString " " (gl.hexToRgb " " hex));
in
{
  options.gruvbox.sioyek = gl.mkModule "sioyek";

  config = lib.mkIf cfg.enable {
    programs.sioyek.config = gl.mkDefaults {
      background_color = f p.bg;
      text_highlight_color = f p.accent;
      visual_mark_color = "${f p.accent} 0.3";
      search_highlight_color = f p.yellow;
      link_highlight_color = f p.blue;
      synctex_highlight_color = f p.green;
      custom_background_color = f p.bg;
      custom_text_color = f p.fg;
      status_bar_color = f p.bg1;
      status_bar_text_color = f p.fg;
      ui_text_color = f p.fg;
      ui_background_color = f p.bg;
      ui_selected_text_color = f p.bg;
      ui_selected_background_color = f p.accent;
    };
  };
}
