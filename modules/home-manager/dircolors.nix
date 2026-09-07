{ config, lib, ... }:

let
  cfg = config.gruvbox.dircolors;
  a = config.gruvbox.ansi;
  fg = c: "38;2;${c}";
in
{
  options.gruvbox.dircolors.enable =
    lib.mkEnableOption "gruvbox for dircolors (LS_COLORS)" // { default = config.gruvbox.enable; };

  config = lib.mkIf cfg.enable {
    # home-manager ships its own mkDefault for these keys; 900 beats that, plain user config still wins
    programs.dircolors.settings = lib.mapAttrs (_: lib.mkOverride 900) {
      NORMAL = fg a.fg;
      FILE = fg a.fg;
      DIR = "1;${fg a.blue}";
      LINK = fg a.aqua;
      ORPHAN = fg a.red;
      MISSING = fg a.red;
      EXEC = fg a.green;
      FIFO = fg a.yellow;
      SOCK = fg a.purple;
      BLK = fg a.neutralYellow;
      CHR = fg a.aqua;
      SETUID = "1;${fg a.red}";
      SETGID = fg a.red;
      STICKY = fg a.neutralBlue;
      OTHER_WRITABLE = fg a.purple;
      STICKY_OTHER_WRITABLE = "1;${fg a.purple}";
    };
  };
}
