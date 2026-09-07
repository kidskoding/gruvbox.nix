{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.eza;
  a = gl.ansiOf cfg;
  inherit (gl) fg;

  # eza layers these on top of LS_COLORS
  colors = {
    ur = "0"; uw = "0"; ux = "0";
    gr = "0"; gw = "0"; gx = "0";
    tr = "0"; tx = "0";

    lp = fg a.aqua;                 # symlink target
    sn = fg a.yellow;               # size number
    sb = fg a.fg4;                  # size unit
    da = fg a.neutralBlue;          # date
    hd = "1;${fg a.neutralPurple}"; # table header

    im = fg a.green;                # image
    vi = fg a.neutralPurple;        # video
    mu = fg a.aqua;                 # music
    lo = fg a.aqua;                 # lossless audio
    cr = fg a.red;                  # crypto
    do = fg a.blue;                 # document
    co = fg a.yellow;               # compressed
    tm = fg a.fg4;                  # temp
  };
in
{
  options.gruvbox.eza = gl.mkModule "eza";

  config = lib.mkIf cfg.enable {
    home.sessionVariables.EZA_COLORS = lib.mkDefault
      (lib.concatStringsSep ":" (lib.mapAttrsToList (k: v: "${k}=${v}") colors));
  };
}
