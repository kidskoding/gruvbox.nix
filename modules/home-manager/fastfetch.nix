{ config, lib, ... }:

let
  cfg = config.gruvbox.fastfetch;
  a = config.gruvbox.ansi;
in
{
  options.gruvbox.fastfetch.enable =
    lib.mkEnableOption "gruvbox for fastfetch (key/title/separator colors)" // { default = config.gruvbox.enable; };

  config = lib.mkIf cfg.enable {
    programs.fastfetch.settings.display.color = {
      keys = lib.mkDefault "38;2;${a.accent}";
      title = lib.mkDefault "38;2;${a.accent}";
      separator = lib.mkDefault "38;2;${a.gray}";
    };
  };
}
