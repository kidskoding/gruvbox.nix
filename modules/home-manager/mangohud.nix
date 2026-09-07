{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.mangohud;
  p = gl.paletteOf cfg;
  c = gl.noHash;
in
{
  options.gruvbox.mangohud = gl.mkModule "mangohud";

  config = lib.mkIf cfg.enable {
    programs.mangohud.settings = gl.mkDefaults {
      text_color = c p.fg;
      background_color = c p.bg;
      gpu_color = c p.green;
      cpu_color = c p.blue;
      vram_color = c p.aqua;
      ram_color = c p.purple;
      engine_color = c p.purple;
      io_color = c p.yellow;
      frametime_color = c p.green;
      media_player_color = c p.fg;
      wine_color = c p.red;
      battery_color = c p.orange;
    };
  };
}
