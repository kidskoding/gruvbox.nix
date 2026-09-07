{ config, lib, options }:

let
  gl = import ../lib;
  g = config.gruvbox;
  enum = lib.types.enum;
in
rec {
  mkModule = name: {
    enable = lib.mkEnableOption "gruvbox for ${name}" // { default = g.enable; };
    flavor = lib.mkOption {
      type = enum [ "dark" "light" ];
      default = g.flavor;
      description = "flavor for ${name}, defaults to gruvbox.flavor.";
    };
    contrast = lib.mkOption {
      type = enum [ "hard" "medium" "soft" ];
      default = g.contrast;
      description = "contrast for ${name}, defaults to gruvbox.contrast.";
    };
    accent = lib.mkOption {
      type = enum [ "red" "green" "yellow" "blue" "purple" "aqua" "orange" ];
      default = g.accent;
      description = "accent for ${name}, defaults to gruvbox.accent.";
    };
  };

  paletteOf = cfg: gl.palette { inherit (cfg) flavor contrast accent; };
  ansiOf = cfg: lib.mapAttrs (_: gl.hexToRgb ";") (paletteOf cfg);

  # ansi 0-15
  term16 = p: [
    p.bg p.neutralRed p.neutralGreen p.neutralYellow p.neutralBlue p.neutralPurple p.neutralAqua p.fg4
    p.gray p.red p.green p.yellow p.blue p.purple p.aqua p.fg
  ];

  mkDefaults = lib.mapAttrsRecursive (_: lib.mkDefault);
  fg = c: "38;2;${c}";
  noHash = builtins.replaceStrings [ "#" ] [ "" ];
  hasOpt = path: lib.hasAttrByPath path options;
  inherit (gl) hexToRgb;
}
