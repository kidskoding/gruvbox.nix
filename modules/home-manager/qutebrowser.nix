{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.qutebrowser;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.qutebrowser = gl.mkModule "qutebrowser";

  config = lib.mkIf cfg.enable {
    programs.qutebrowser.settings.colors = gl.mkDefaults {
      webpage.preferred_color_scheme = cfg.flavor;
      completion = {
        fg = p.fg; odd.bg = p.bg; even.bg = p.bg;
        category = { fg = p.accent; bg = p.bg1; border.top = p.bg1; border.bottom = p.bg1; };
        item.selected = { fg = p.bg; bg = p.accent; border.top = p.accent; border.bottom = p.accent; match.fg = p.bg; };
        match.fg = p.accent;
        scrollbar = { fg = p.fg4; bg = p.bg; };
      };
      contextmenu = {
        menu = { bg = p.bg; fg = p.fg; };
        selected = { bg = p.accent; fg = p.bg; };
        disabled = { bg = p.bg; fg = p.fg4; };
      };
      downloads = {
        bar.bg = p.bg;
        start = { fg = p.bg; bg = p.blue; };
        stop = { fg = p.bg; bg = p.green; };
        error.fg = p.red;
      };
      hints = { fg = p.bg; bg = p.yellow; match.fg = p.fg4; };
      keyhint = { fg = p.fg; suffix.fg = p.accent; bg = p.bg; };
      messages = {
        error = { fg = p.bg; bg = p.red; border = p.red; };
        warning = { fg = p.bg; bg = p.yellow; border = p.yellow; };
        info = { fg = p.fg; bg = p.bg; border = p.bg; };
      };
      prompts = { fg = p.fg; bg = p.bg; border = p.accent; selected = { fg = p.bg; bg = p.accent; }; };
      statusbar = {
        normal = { fg = p.fg; bg = p.bg; };
        insert = { fg = p.bg; bg = p.green; };
        passthrough = { fg = p.bg; bg = p.blue; };
        private = { fg = p.fg; bg = p.bg1; };
        command = { fg = p.fg; bg = p.bg; private = { fg = p.fg; bg = p.bg1; }; };
        caret = { fg = p.bg; bg = p.purple; selection = { fg = p.bg; bg = p.purple; }; };
        progress.bg = p.accent;
        url = {
          fg = p.fg; error.fg = p.red; hover.fg = p.aqua;
          success.http.fg = p.green; success.https.fg = p.green; warn.fg = p.yellow;
        };
      };
      tabs = {
        bar.bg = p.bg0_h;
        indicator = { start = p.blue; stop = p.green; error = p.red; };
        odd = { fg = p.fg4; bg = p.bg0_h; };
        even = { fg = p.fg4; bg = p.bg0_h; };
        selected = { odd = { fg = p.fg; bg = p.bg; }; even = { fg = p.fg; bg = p.bg; }; };
        pinned = {
          odd = { fg = p.fg4; bg = p.bg1; }; even = { fg = p.fg4; bg = p.bg1; };
          selected = { odd = { fg = p.fg; bg = p.bg; }; even = { fg = p.fg; bg = p.bg; }; };
        };
      };
    };
  };
}
