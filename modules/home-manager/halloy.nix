{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.halloy;
  p = gl.paletteOf cfg;
  buttons = { background = p.bg; background_hover = p.bg1; background_selected = p.bg2; background_selected_hover = p.bg3; };
in
{
  options.gruvbox.halloy = gl.mkModule "halloy";

  config = lib.mkIf cfg.enable {
    programs.halloy = {
      settings.theme = lib.mkDefault "gruvbox";
      themes.gruvbox = {
        general = { background = p.bg; border = p.bg1; horizontal_rule = p.bg1; unread_indicator = p.accent; };
        text = { primary = p.fg; secondary = p.fg4; tertiary = p.gray; success = p.green; error = p.red; };
        buffer = {
          action = p.aqua;
          background = p.bg;
          background_text_input = p.bg0_h;
          background_title_bar = p.bg1;
          border = p.bg1;
          border_selected = p.accent;
          code = p.purple;
          highlight = p.bg1;
          nickname = p.yellow;
          selection = p.bg2;
          timestamp = p.gray;
          topic = p.fg4;
          url = p.blue;
          server_messages.default = p.gray;
        };
        buttons = { primary = buttons; secondary = buttons; };
      };
    };
  };
}
