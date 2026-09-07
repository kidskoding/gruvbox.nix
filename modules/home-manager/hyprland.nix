{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.hyprland;
  p = gl.paletteOf cfg;
  rgb = h: "rgb(${gl.noHash h})";
in
{
  options.gruvbox.hyprland = gl.mkModule "hyprland";

  # $gruvbox_<key> variables are also defined for your own rules
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = gl.mkDefaults ({
      general = {
        "col.active_border" = rgb p.accent;
        "col.inactive_border" = rgb p.bg1;
      };
      misc.background_color = rgb p.bg;
      decoration.shadow.color = "rgba(${gl.noHash p.bg0_h}ee)";
    } // lib.mapAttrs' (k: v: lib.nameValuePair "$gruvbox_${k}" (rgb v)) p);
  };
}
