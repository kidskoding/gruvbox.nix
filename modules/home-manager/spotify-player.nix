{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.spotify-player;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.spotify-player = gl.mkModule "spotify-player";

  config = lib.mkIf cfg.enable {
    programs.spotify-player = {
      settings.theme = lib.mkDefault "gruvbox";
      themes = [{
        name = "gruvbox";
        palette = {
          background = p.bg; foreground = p.fg;
          black = p.bg; red = p.neutralRed; green = p.neutralGreen; yellow = p.neutralYellow;
          blue = p.neutralBlue; magenta = p.neutralPurple; cyan = p.neutralAqua; white = p.fg4;
          bright_black = p.gray; bright_red = p.red; bright_green = p.green; bright_yellow = p.yellow;
          bright_blue = p.blue; bright_magenta = p.purple; bright_cyan = p.aqua; bright_white = p.fg;
        };
        component_style = {
          block_title = { fg = p.accent; };
          border = { fg = p.bg2; };
          playback_track = { fg = p.fg; modifiers = [ "Bold" ]; };
          playback_artists = { fg = p.aqua; modifiers = [ "Bold" ]; };
          playback_album = { fg = p.yellow; };
          playback_metadata = { fg = p.fg4; };
          playback_progress_bar = { bg = p.bg1; fg = p.accent; };
          current_playing = { fg = p.green; modifiers = [ "Bold" ]; };
          page_desc = { fg = p.accent; modifiers = [ "Bold" ]; };
          table_header = { fg = p.blue; };
          selection = { fg = p.bg; bg = p.accent; modifiers = [ "Bold" ]; };
        };
      }];
    };
  };
}
