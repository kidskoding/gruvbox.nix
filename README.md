# gruvbox.nix

gruvbox for nixos and home-manager. one switch, every app, no upstream theme
files fetched: everything is generated from the palette.

## use

```nix
# flake.nix
inputs.gruvbox = {
  url = "github:kidskoding/gruvbox.nix";
  inputs.nixpkgs.follows = "nixpkgs";
  inputs.home-manager.follows = "home-manager";
};
```

```nix
# home-manager
{ inputs, ... }: {
  imports = [ inputs.gruvbox.homeModules.default ];
  gruvbox = {
    enable = true;
    flavor = "dark";      # dark | light
    contrast = "medium";  # hard | medium | soft
    accent = "orange";    # red green yellow blue purple aqua orange
  };
}
```

```nix
# nixos (greeter)
{ inputs, ... }: {
  imports = [ inputs.gruvbox.nixosModules.default ];
  gruvbox.enable = true;
}
```

Every app module is on when `gruvbox.enable` is; turn one off with
`gruvbox.<app>.enable = false`. Values are set with `mkDefault`, your own
config wins.

## modules

home-manager: alacritty, dircolors, doom (emacs), eza, fastfetch, fish, gtk,
niri, noctalia, qt, starship, zellij. nixos: noctalia-greeter.

doom: the module writes `~/.config/doom/gruvbox.el`; add `(load! "gruvbox")`
to your config.el and keep `(package! gruvbox-theme)` in packages.el.

## palette

`config.gruvbox.palette.<key>` gives `#rrggbb`; `.rgb.<key>` gives `R, G, B`;
`.ansi.<key>` gives `R;G;B`. keys: `bg0_h bg0 bg0_s bg1 bg2 bg3 bg4 fg0 fg1 fg2
fg3 fg4 gray red green yellow blue purple aqua orange neutralRed neutralGreen
neutralYellow neutralBlue neutralPurple neutralAqua neutralOrange bg fg accent`.

outside the module system: `inputs.gruvbox.lib.palette { flavor = "dark"; contrast = "hard"; accent = "aqua"; }`.

## check

`nix flake check` runs the palette unit test and evaluates a home-manager
config with every module on.
