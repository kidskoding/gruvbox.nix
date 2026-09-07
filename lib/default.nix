let
  digit = {
    "0" = 0; "1" = 1; "2" = 2; "3" = 3; "4" = 4;
    "5" = 5; "6" = 6; "7" = 7; "8" = 8; "9" = 9;
    a = 10; b = 11; c = 12; d = 13; e = 14; f = 15;
  };
  byte = s: digit.${builtins.substring 0 1 s} * 16 + digit.${builtins.substring 1 1 s};

  dark = {
    bg0_h = "#1d2021"; bg0 = "#282828"; bg0_s = "#32302f";
    bg1 = "#3c3836"; bg2 = "#504945"; bg3 = "#665c54"; bg4 = "#7c6f64";
    fg0 = "#fbf1c7"; fg1 = "#ebdbb2"; fg2 = "#d5c4a1"; fg3 = "#bdae93"; fg4 = "#a89984";
    red = "#fb4934"; green = "#b8bb26"; yellow = "#fabd2f"; blue = "#83a598";
    purple = "#d3869b"; aqua = "#8ec07c"; orange = "#fe8019";
  };

  light = {
    bg0_h = "#f9f5d7"; bg0 = "#fbf1c7"; bg0_s = "#f2e5bc";
    bg1 = "#ebdbb2"; bg2 = "#d5c4a1"; bg3 = "#bdae93"; bg4 = "#a89984";
    fg0 = "#282828"; fg1 = "#3c3836"; fg2 = "#504945"; fg3 = "#665c54"; fg4 = "#7c6f64";
    red = "#9d0006"; green = "#79740e"; yellow = "#b57614"; blue = "#076678";
    purple = "#8f3f71"; aqua = "#427b58"; orange = "#af3a03";
  };

  shared = {
    gray = "#928374";
    neutralRed = "#cc241d"; neutralGreen = "#98971a"; neutralYellow = "#d79921";
    neutralBlue = "#458588"; neutralPurple = "#b16286"; neutralAqua = "#689d6a";
    neutralOrange = "#d65d0e";
  };
in
{
  # "#rrggbb" -> "R<sep>G<sep>B"
  hexToRgb = sep: hex:
    let h = builtins.substring 1 6 hex; in
    builtins.concatStringsSep sep (map (i: toString (byte (builtins.substring i 2 h))) [ 0 2 4 ]);

  palette = { flavor ? "dark", contrast ? "medium", accent ? "orange" }:
    let base = (if flavor == "light" then light else dark) // shared; in
    base // {
      bg = { hard = base.bg0_h; medium = base.bg0; soft = base.bg0_s; }.${contrast};
      fg = base.fg1;
      accent = base.${accent};
    };
}
