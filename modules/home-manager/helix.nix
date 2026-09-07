{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.helix;
  # helix ships all six: gruvbox, gruvbox_light and the _hard/_soft variants of each
  theme =
    if cfg.contrast == "medium"
    then (if cfg.flavor == "dark" then "gruvbox" else "gruvbox_light")
    else "gruvbox_${cfg.flavor}_${cfg.contrast}";
in
{
  options.gruvbox.helix = gl.mkModule "helix";

  config = lib.mkIf cfg.enable {
    programs.helix.settings.theme = lib.mkDefault theme;
  };
}
