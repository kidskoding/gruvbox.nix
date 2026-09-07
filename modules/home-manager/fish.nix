{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.fish;
  p = gl.paletteOf cfg;

  colors = {
    fish_color_normal = p.fg;
    fish_color_command = p.green;
    fish_color_keyword = p.red;
    fish_color_quote = p.yellow;
    fish_color_redirection = p.purple;
    fish_color_end = p.orange;
    fish_color_error = p.red;
    fish_color_param = p.fg;
    fish_color_option = p.aqua;
    fish_color_comment = p.gray;
    fish_color_operator = p.aqua;
    fish_color_escape = p.aqua;
    fish_color_autosuggestion = p.bg4;
    fish_color_cancel = p.red;
    fish_color_selection = "--background=${p.bg1}";
    fish_color_search_match = "--background=${p.bg1}";
    fish_color_valid_path = "--underline";
    fish_color_cwd = p.blue;
    fish_color_host = p.aqua;
    fish_color_user = p.yellow;
    fish_pager_color_progress = "${p.bg} --background=${p.yellow}";
    fish_pager_color_prefix = p.blue;
    fish_pager_color_completion = p.fg;
    fish_pager_color_description = p.gray;
    fish_pager_color_selected_background = "--background=${p.bg1}";
  };
in
{
  options.gruvbox.fish = gl.mkModule "fish";

  # fish takes bare rrggbb; a leading # would start a comment
  config = lib.mkIf cfg.enable {
    programs.fish.interactiveShellInit = lib.mkBefore
      (lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "set -g ${k} ${gl.noHash v}") colors));
  };
}
