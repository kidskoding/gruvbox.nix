{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.zsh;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.zsh = gl.mkModule "zsh syntax highlighting";

  config = lib.mkIf cfg.enable {
    programs.zsh.syntaxHighlighting.styles = gl.mkDefaults {
      default = "fg=${p.fg}";
      unknown-token = "fg=${p.red}";
      reserved-word = "fg=${p.red}";
      alias = "fg=${p.green}";
      builtin = "fg=${p.green}";
      function = "fg=${p.green}";
      command = "fg=${p.green}";
      precommand = "fg=${p.green},italic";
      commandseparator = "fg=${p.orange}";
      hashed-command = "fg=${p.green}";
      path = "fg=${p.fg},underline";
      globbing = "fg=${p.aqua}";
      history-expansion = "fg=${p.purple}";
      single-hyphen-option = "fg=${p.aqua}";
      double-hyphen-option = "fg=${p.aqua}";
      back-quoted-argument = "fg=${p.purple}";
      single-quoted-argument = "fg=${p.yellow}";
      double-quoted-argument = "fg=${p.yellow}";
      dollar-double-quoted-argument = "fg=${p.aqua}";
      back-double-quoted-argument = "fg=${p.aqua}";
      assign = "fg=${p.fg}";
      redirection = "fg=${p.purple}";
      comment = "fg=${p.gray},italic";
      arg0 = "fg=${p.fg}";
    };
  };
}
