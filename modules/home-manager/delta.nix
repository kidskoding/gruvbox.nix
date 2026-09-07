{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.delta;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.delta = gl.mkModule "delta";

  config = lib.mkIf cfg.enable {
    programs.delta.options = gl.mkDefaults {
      syntax-theme = "gruvbox-${cfg.flavor}";
      minus-style = "${p.red} ${p.bg1}";
      minus-emph-style = "${p.bg} ${p.red}";
      plus-style = "${p.green} ${p.bg1}";
      plus-emph-style = "${p.bg} ${p.green}";
      line-numbers-minus-style = p.red;
      line-numbers-plus-style = p.green;
      line-numbers-zero-style = p.gray;
      file-style = "bold ${p.accent}";
      hunk-header-decoration-style = "${p.bg2} box";
    };
  };
}
