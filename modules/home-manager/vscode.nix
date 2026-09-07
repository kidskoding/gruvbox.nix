{ config, lib, options, pkgs, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.vscode;
  cap = s: lib.toUpper (builtins.substring 0 1 s) + builtins.substring 1 (-1) s;
in
{
  options.gruvbox.vscode = gl.mkModule "vscode";

  config = lib.mkIf cfg.enable {
    programs.vscode.profiles.default = {
      extensions = [ pkgs.vscode-extensions.jdinhlife.gruvbox ];
      userSettings."workbench.colorTheme" = lib.mkDefault "Gruvbox ${cap cfg.flavor} ${cap cfg.contrast}";
    };
  };
}
