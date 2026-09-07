# run: nix eval --file lib/test.nix
let
  l = import ./.;
  dark = l.palette { flavor = "dark"; contrast = "hard"; accent = "orange"; };
  medium = l.palette { flavor = "dark"; contrast = "medium"; accent = "yellow"; };
  light = l.palette { flavor = "light"; contrast = "soft"; accent = "blue"; };
in
assert dark.bg == "#1d2021";
assert dark.fg == "#ebdbb2";
assert dark.accent == "#fe8019";
assert medium.bg == "#282828";
assert medium.accent == "#fabd2f";
assert light.bg == "#f2e5bc";
assert light.fg == "#3c3836";
assert light.accent == "#076678";
assert light.neutralRed == "#cc241d";
assert l.hexToRgb ";" "#fe8019" == "254;128;25";
assert l.hexToRgb ", " "#000000" == "0, 0, 0";
assert l.hexToRgb ";" "#ffffff" == "255;255;255";
"ok"
