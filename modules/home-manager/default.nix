{
  _class = "homeManager";

  imports = [ ../palette.nix ] ++ map (f: ./. + "/${f}") (builtins.filter
    (f: f != "default.nix" && builtins.match ".*\\.nix" f != null)
    (builtins.attrNames (builtins.readDir ./.)));
}
