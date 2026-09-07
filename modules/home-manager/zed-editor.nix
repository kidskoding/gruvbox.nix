{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.zed-editor;
  cap = s: lib.toUpper (builtins.substring 0 1 s) + builtins.substring 1 (-1) s;
in
{
  options.gruvbox.zed-editor = gl.mkModule "zed-editor";

  # zed ships all six variants; medium is plain "Gruvbox Dark" / "Gruvbox Light"
  config = lib.mkIf cfg.enable {
    programs.zed-editor.userSettings.theme = lib.mkDefault
      ("Gruvbox ${cap cfg.flavor}" + lib.optionalString (cfg.contrast != "medium") " ${cap cfg.contrast}");
  };
}
