{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.lazygit;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.lazygit = gl.mkModule "lazygit";

  config = lib.mkIf cfg.enable {
    programs.lazygit.settings.gui.theme = gl.mkDefaults {
      activeBorderColor = [ p.accent "bold" ];
      inactiveBorderColor = [ p.gray ];
      searchingActiveBorderColor = [ p.yellow "bold" ];
      optionsTextColor = [ p.blue ];
      selectedLineBgColor = [ p.bg1 ];
      inactiveViewSelectedLineBgColor = [ p.bg1 ];
      cherryPickedCommitBgColor = [ p.bg2 ];
      cherryPickedCommitFgColor = [ p.aqua ];
      unstagedChangesColor = [ p.red ];
      defaultFgColor = [ p.fg ];
    };
  };
}
