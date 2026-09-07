{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.nushell;
  p = gl.paletteOf cfg;
  colors = {
    separator = p.fg4;
    leading_trailing_space_bg = p.bg1;
    header = "${p.green} bold";
    empty = p.blue;
    bool = p.purple;
    int = p.fg;
    filesize = p.aqua;
    duration = p.fg;
    date = p.purple;
    range = p.fg;
    float = p.fg;
    string = p.green;
    nothing = p.fg;
    binary = p.fg;
    cellpath = p.fg;
    row_index = "${p.aqua} bold";
    record = p.fg;
    list = p.fg;
    block = p.fg;
    hints = p.bg4;
    search_result = "${p.bg} ${p.red}";
    shape_binary = "${p.purple} bold";
    shape_block = "${p.blue} bold";
    shape_bool = p.aqua;
    shape_custom = p.green;
    shape_datetime = "${p.aqua} bold";
    shape_directory = p.aqua;
    shape_external = p.aqua;
    shape_externalarg = "${p.green} bold";
    shape_filepath = p.aqua;
    shape_flag = "${p.blue} bold";
    shape_float = "${p.purple} bold";
    shape_garbage = "${p.bg} ${p.red} bold";
    shape_globpattern = "${p.aqua} bold";
    shape_int = "${p.purple} bold";
    shape_internalcall = "${p.aqua} bold";
    shape_keyword = "${p.red} bold";
    shape_list = "${p.aqua} bold";
    shape_literal = p.blue;
    shape_match_pattern = p.green;
    shape_matching_brackets = "${p.accent} underline";
    shape_nothing = p.aqua;
    shape_operator = p.yellow;
    shape_pipe = "${p.purple} bold";
    shape_range = "${p.yellow} bold";
    shape_record = "${p.aqua} bold";
    shape_redirection = "${p.purple} bold";
    shape_signature = "${p.green} bold";
    shape_string = p.green;
    shape_string_interpolation = "${p.aqua} bold";
    shape_table = "${p.blue} bold";
    shape_variable = p.purple;
    shape_vardecl = p.purple;
  };
  toNu = attrs: "{ " + lib.concatStringsSep ", " (lib.mapAttrsToList (k: v: "${k}: \"${v}\"") attrs) + " }";
in
{
  options.gruvbox.nushell = gl.mkModule "nushell";

  # mkBefore so your own $env.config.color_config assignments win
  config = lib.mkIf cfg.enable {
    programs.nushell.extraConfig = lib.mkBefore ''
      $env.config.color_config = ${toNu colors}
    '';
  };
}
