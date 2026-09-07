{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.niri;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.niri = gl.mkModule "niri";

  # no-op unless niri-flake's home-manager module is imported
  config = lib.mkIf cfg.enable (lib.optionalAttrs (gl.hasOpt [ "programs" "niri" ]) {
    programs.niri.settings.layout = gl.mkDefaults {
      background-color = p.bg;
      border.active.color = p.accent;
      border.inactive.color = p.bg1;
      shadow.color = "${p.bg0_h}ee";
    };
  });
}
