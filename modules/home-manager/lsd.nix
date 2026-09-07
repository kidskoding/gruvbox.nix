{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.lsd;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.lsd = gl.mkModule "lsd";

  config = lib.mkIf cfg.enable {
    programs.lsd.colors = gl.mkDefaults {
      user = p.yellow;
      group = p.aqua;
      permission = {
        read = p.green;
        write = p.yellow;
        exec = p.red;
        exec-sticky = p.purple;
        no-access = p.gray;
        octal = p.aqua;
        acl = p.aqua;
        context = p.aqua;
      };
      date = { hour-old = p.aqua; day-old = p.green; older = p.gray; };
      size = { none = p.gray; small = p.green; medium = p.yellow; large = p.red; };
      inode = { valid = p.purple; invalid = p.gray; };
      links = { valid = p.purple; invalid = p.gray; };
      tree-edge = p.bg3;
      git-status = {
        default = p.fg;
        unmodified = p.gray;
        ignored = p.gray;
        new-in-index = p.green;
        new-in-workdir = p.green;
        typechange = p.yellow;
        deleted = p.red;
        renamed = p.aqua;
        modified = p.yellow;
        conflicted = p.red;
      };
    };
  };
}
