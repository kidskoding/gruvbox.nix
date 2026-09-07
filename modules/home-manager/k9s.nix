{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.k9s;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.k9s = gl.mkModule "k9s";

  config = lib.mkIf cfg.enable {
    programs.k9s = {
      settings.k9s.ui.skin = lib.mkDefault "gruvbox";
      skins.gruvbox = gl.mkDefaults {
        k9s = {
          body = { fgColor = p.fg; bgColor = p.bg; logoColor = p.accent; };
          prompt = { fgColor = p.fg; bgColor = p.bg; suggestColor = p.accent; };
          info = { fgColor = p.blue; sectionColor = p.fg; };
          dialog = {
            fgColor = p.fg; bgColor = p.bg;
            buttonFgColor = p.fg; buttonBgColor = p.purple;
            buttonFocusFgColor = p.bg; buttonFocusBgColor = p.accent;
            labelFgColor = p.yellow; fieldFgColor = p.fg;
          };
          frame = {
            border = { fgColor = p.bg2; focusColor = p.accent; };
            menu = { fgColor = p.fg; keyColor = p.accent; numKeyColor = p.purple; };
            crumbs = { fgColor = p.bg; bgColor = p.accent; activeColor = p.yellow; };
            status = {
              newColor = p.blue; modifyColor = p.purple; addColor = p.green;
              errorColor = p.red; highlightColor = p.accent; killColor = p.orange; completedColor = p.gray;
            };
            title = {
              fgColor = p.fg; bgColor = p.bg;
              highlightColor = p.accent; counterColor = p.purple; filterColor = p.green;
            };
          };
          views = {
            charts = { bgColor = p.bg; defaultDialColors = [ p.green p.red ]; defaultChartColors = [ p.green p.red ]; };
            table = {
              fgColor = p.fg; bgColor = p.bg; cursorFgColor = p.bg; cursorBgColor = p.accent; markColor = p.yellow;
              header = { fgColor = p.fg; bgColor = p.bg; sorterColor = p.aqua; };
            };
            xray = { fgColor = p.fg; bgColor = p.bg; cursorColor = p.accent; graphicColor = p.purple; showIcons = false; };
            yaml = { keyColor = p.blue; colonColor = p.fg4; valueColor = p.fg; };
            logs = {
              fgColor = p.fg; bgColor = p.bg;
              indicator = { fgColor = p.fg; bgColor = p.bg; toggleOnColor = p.green; toggleOffColor = p.red; };
            };
          };
        };
      };
    };
  };
}
