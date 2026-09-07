{ config, lib, options, pkgs, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.neovim;
in
{
  options.gruvbox.neovim = gl.mkModule "neovim";

  # mkBefore so a colorscheme call in your own lua wins
  config = lib.mkIf cfg.enable {
    programs.neovim = {
      plugins = [ pkgs.vimPlugins.gruvbox-nvim ];
      extraLuaConfig = lib.mkBefore ''
        vim.o.background = "${cfg.flavor}"
        require("gruvbox").setup({ contrast = "${if cfg.contrast == "medium" then "" else cfg.contrast}" })
        vim.cmd.colorscheme("gruvbox")
      '';
    };
  };
}
