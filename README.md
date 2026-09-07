# gruvbox.nix

[![check](https://github.com/kidskoding/gruvbox.nix/actions/workflows/check.yml/badge.svg)](https://github.com/kidskoding/gruvbox.nix/actions/workflows/check.yml)

[gruvbox](https://github.com/morhetz/gruvbox) for NixOS and home-manager. One
switch themes every supported program from a single palette. Nothing is fetched
from upstream theme repositories: every config is generated in Nix from the
palette, so the whole thing is one flake with no ports to track.

```nix
gruvbox.enable = true;
```

- [Getting started](#getting-started)
  - [Flake input](#flake-input)
  - [home-manager](#home-manager)
  - [NixOS](#nixos)
  - [NixOS with home-manager as a module](#nixos-with-home-manager-as-a-module)
  - [Without flakes](#without-flakes)
- [Options](#options)
  - [Global](#global)
  - [Per module](#per-module)
- [Modules](#modules)
  - [home-manager modules](#home-manager-modules)
  - [NixOS modules](#nixos-modules)
  - [Module notes](#module-notes)
- [Palette](#palette)
  - [Keys](#keys)
  - [Dark](#dark)
  - [Light](#light)
  - [Derived keys](#derived-keys)
  - [Formats](#formats)
  - [Using the palette in your own config](#using-the-palette-in-your-own-config)
  - [Outside the module system](#outside-the-module-system)
- [Overriding](#overriding)
- [Adding a module](#adding-a-module)
- [Checks](#checks)
- [FAQ](#faq)
- [License](#license)

## Getting started

### Flake input

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gruvbox = {
      url = "github:kidskoding/gruvbox.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };
}
```

`gruvbox.nix` only uses its `nixpkgs` and `home-manager` inputs for its own
checks. Following yours keeps your lock file small.

The flake exports:

| output                 | what it is                                      |
|------------------------|-------------------------------------------------|
| `homeModules.default`  | home-manager module: options + every hm module   |
| `nixosModules.default` | NixOS module: options + every NixOS module       |
| `lib.palette`          | pure function, see [Outside the module system](#outside-the-module-system) |
| `lib.hexToRgb`         | `sep -> "#rrggbb" -> "R<sep>G<sep>B"`            |
| `checks.<system>`      | see [Checks](#checks)                            |

### home-manager

```nix
{ inputs, ... }:
{
  imports = [ inputs.gruvbox.homeModules.default ];

  gruvbox = {
    enable = true;
    flavor = "dark";     # dark | light
    contrast = "medium"; # hard | medium | soft
    accent = "orange";   # red | green | yellow | blue | purple | aqua | orange
  };
}
```

That is the whole setup. Every home-manager module in the
[table below](#home-manager-modules) turns on, and each one only does something
when the program it themes is enabled (`programs.alacritty.enable = true` and so
on), so importing the flake never adds programs you did not ask for.

### NixOS

```nix
{ inputs, ... }:
{
  imports = [ inputs.gruvbox.nixosModules.default ];

  gruvbox.enable = true;
}
```

The NixOS side has the same global options as home-manager and its own set of
[NixOS modules](#nixos-modules). The two sides are independent: set `flavor`,
`contrast` and `accent` on each one you use.

### NixOS with home-manager as a module

```nix
{
  nixosConfigurations.machine = nixpkgs.lib.nixosSystem {
    modules = [
      inputs.gruvbox.nixosModules.default
      { gruvbox.enable = true; }

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.users.you = {
          imports = [ inputs.gruvbox.homeModules.default ];
          gruvbox.enable = true;
        };
      }
    ];
  };
}
```

### Without flakes

```nix
let
  gruvbox = builtins.fetchTarball "https://github.com/kidskoding/gruvbox.nix/archive/master.tar.gz";
in
{
  imports = [ "${gruvbox}/modules/home-manager" ]; # or "${gruvbox}/modules/nixos"
  gruvbox.enable = true;
}
```

## Options

### Global

Declared on both the home-manager and NixOS side.

| option             | type                                                                 | default    | description |
|--------------------|----------------------------------------------------------------------|------------|-------------|
| `gruvbox.enable`   | bool                                                                 | `false`    | master switch; every `gruvbox.<module>.enable` defaults to this |
| `gruvbox.flavor`   | `"dark"` \| `"light"`                                                | `"dark"`   | which gruvbox |
| `gruvbox.contrast` | `"hard"` \| `"medium"` \| `"soft"`                                   | `"medium"` | picks `bg0_h`, `bg0` or `bg0_s` as the main background `bg` |
| `gruvbox.accent`   | `"red"` `"green"` `"yellow"` `"blue"` `"purple"` `"aqua"` `"orange"` | `"orange"` | highlight color: active borders, primary UI slots, prompt keys |
| `gruvbox.palette`  | attrs of `#rrggbb` strings, read-only                                | derived    | the full palette, see [Palette](#palette) |
| `gruvbox.rgb`      | attrs of `"R, G, B"` strings, read-only                              | derived    | same keys, for CSS `rgba()` |
| `gruvbox.ansi`     | attrs of `"R;G;B"` strings, read-only                                | derived    | same keys, for `38;2;R;G;B` truecolor escapes |

### Per module

Every module declares exactly one option:

```nix
gruvbox.<module>.enable  # bool, default = config.gruvbox.enable
```

Turn one module off while keeping the rest:

```nix
gruvbox.enable = true;
gruvbox.starship.enable = false;
```

Or theme a single program without the master switch:

```nix
gruvbox.enable = false;
gruvbox.alacritty.enable = true;
```

## Modules

A module maps the palette onto one program's existing home-manager or NixOS
options. It never writes files a program would not read anyway and never
installs the program itself.

### home-manager modules

| module            | sets                                                                 | needs |
|-------------------|----------------------------------------------------------------------|-------|
| `alacritty`       | `programs.alacritty.settings.colors` (primary, normal, bright)       | `programs.alacritty.enable` |
| `dircolors`       | `programs.dircolors.settings` (LS_COLORS for ls, grep, fd, eza)      | `programs.dircolors.enable` |
| `doom`            | `~/.config/doom/gruvbox.el`: `doom-theme` by flavor and contrast, mode-line and dired faces | doom emacs, see [notes](#doom) |
| `eza`             | `home.sessionVariables.EZA_COLORS`                                   | nothing |
| `fastfetch`       | `programs.fastfetch.settings.display.color` (keys, title, separator) | `programs.fastfetch.enable` |
| `fish`            | `fish_color_*` and `fish_pager_color_*` via `interactiveShellInit`   | `programs.fish.enable` |
| `gtk`             | `gtk.theme` Gruvbox-Dark/Light, `gtk.iconTheme` Gruvbox-Plus-Dark/Light, `gtk.colorScheme`, dconf `color-scheme` | nothing (sets `gtk.enable`) |
| `niri`            | `programs.niri.settings.layout`: background, active and inactive border, shadow | [niri-flake](https://github.com/sodiboo/niri-flake) module imported |
| `noctalia`        | `programs.noctalia-shell.colors` (material slots) and `settings.colorSchemes` | [noctalia](https://github.com/noctalia-dev/noctalia) module imported |
| `qt`              | dark: qtct platform theme, kvantum style, Gruvbox-Dark-Brown kvantum theme. light: gtk platform theme | nothing (sets `qt.enable`) |
| `starship`        | `programs.starship.settings.palette = "gruvbox"` and `palettes.gruvbox` | `programs.starship.enable` |
| `zellij`          | `programs.zellij.settings.theme = "gruvbox-dark"` or `"gruvbox-light"` | `programs.zellij.enable` |

### NixOS modules

| module             | sets                                                                     | needs |
|--------------------|--------------------------------------------------------------------------|-------|
| `noctalia-greeter` | `programs.noctalia-greeter.settings.appearance`: `scheme = "Synced"`, `theme_mode`, full `palette` | [noctalia-greeter](https://github.com/noctalia-dev/noctalia-greeter) module imported |

### Module notes

#### doom

Doom only loads `config.el`, `init.el` and `packages.el`, so the module writes a
separate `gruvbox.el` next to them and you load it once:

```elisp
;; config.el
(load! "gruvbox")

;; packages.el
(package! gruvbox-theme)
```

Remove any `(setq doom-theme ...)` of your own. `gruvbox.el` picks
`gruvbox-dark-hard`, `gruvbox-light-soft` and so on from `flavor` and
`contrast`, and sets `mode-line` to `bg1`, `mode-line-inactive` to `bg`, and
dired buffers to `bg0_h`.

#### zellij

Zellij ships `gruvbox-dark` and `gruvbox-light` built in, and the module points
at those. `contrast` has no effect on zellij.

#### qt

nixpkgs only packages a dark kvantum theme (`gruvbox-kvantum`,
Gruvbox-Dark-Brown). With `flavor = "light"` the module sets
`qt.platformTheme.name = "gtk"` so Qt follows the gtk theme instead.

#### dircolors

home-manager ships its own defaults for `programs.dircolors.settings`, so the
module sets its values at priority 900: above home-manager's `mkDefault`, still
below anything you write yourself.

#### niri, noctalia, noctalia-greeter

These programs' options come from other flakes. The modules check whether the
option tree exists and become no-ops when it does not, so importing
`gruvbox.nix` never fails on a machine without niri or noctalia.

## Palette

The palette is [morhetz's table](https://github.com/morhetz/gruvbox), complete:
three background levels for contrast, four background and foreground ramps,
seven "bright" colors, seven "neutral" colors, and orange, which most terminal
ports drop because it has no ANSI slot.

### Keys

| group        | keys |
|--------------|------|
| backgrounds  | `bg0_h` `bg0` `bg0_s` `bg1` `bg2` `bg3` `bg4` |
| foregrounds  | `fg0` `fg1` `fg2` `fg3` `fg4` |
| gray         | `gray` |
| bright       | `red` `green` `yellow` `blue` `purple` `aqua` `orange` |
| neutral      | `neutralRed` `neutralGreen` `neutralYellow` `neutralBlue` `neutralPurple` `neutralAqua` `neutralOrange` |
| derived      | `bg` `fg` `accent` |

"Bright" is the set meant for text on the dark background, and is what ANSI
bright colors map to. "Neutral" is the dimmer set, mapped to ANSI normal colors.
On the light flavor "bright" becomes morhetz's faded set, which is the readable
one on a light background; neutral is identical in both flavors.

### Dark

| key     | hex       | key       | hex       |
|---------|-----------|-----------|-----------|
| `bg0_h` | `#1d2021` | `fg0`     | `#fbf1c7` |
| `bg0`   | `#282828` | `fg1`     | `#ebdbb2` |
| `bg0_s` | `#32302f` | `fg2`     | `#d5c4a1` |
| `bg1`   | `#3c3836` | `fg3`     | `#bdae93` |
| `bg2`   | `#504945` | `fg4`     | `#a89984` |
| `bg3`   | `#665c54` | `gray`    | `#928374` |
| `bg4`   | `#7c6f64` |           |           |

| bright   | hex       | neutral         | hex       |
|----------|-----------|-----------------|-----------|
| `red`    | `#fb4934` | `neutralRed`    | `#cc241d` |
| `green`  | `#b8bb26` | `neutralGreen`  | `#98971a` |
| `yellow` | `#fabd2f` | `neutralYellow` | `#d79921` |
| `blue`   | `#83a598` | `neutralBlue`   | `#458588` |
| `purple` | `#d3869b` | `neutralPurple` | `#b16286` |
| `aqua`   | `#8ec07c` | `neutralAqua`   | `#689d6a` |
| `orange` | `#fe8019` | `neutralOrange` | `#d65d0e` |

### Light

| key     | hex       | key       | hex       |
|---------|-----------|-----------|-----------|
| `bg0_h` | `#f9f5d7` | `fg0`     | `#282828` |
| `bg0`   | `#fbf1c7` | `fg1`     | `#3c3836` |
| `bg0_s` | `#f2e5bc` | `fg2`     | `#504945` |
| `bg1`   | `#ebdbb2` | `fg3`     | `#665c54` |
| `bg2`   | `#d5c4a1` | `fg4`     | `#7c6f64` |
| `bg3`   | `#bdae93` | `gray`    | `#928374` |
| `bg4`   | `#a89984` |           |           |

| bright   | hex       | neutral         | hex       |
|----------|-----------|-----------------|-----------|
| `red`    | `#9d0006` | `neutralRed`    | `#cc241d` |
| `green`  | `#79740e` | `neutralGreen`  | `#98971a` |
| `yellow` | `#b57614` | `neutralYellow` | `#d79921` |
| `blue`   | `#076678` | `neutralBlue`   | `#458588` |
| `purple` | `#8f3f71` | `neutralPurple` | `#b16286` |
| `aqua`   | `#427b58` | `neutralAqua`   | `#689d6a` |
| `orange` | `#af3a03` | `neutralOrange` | `#d65d0e` |

### Derived keys

| key      | value |
|----------|-------|
| `bg`     | `bg0_h` when `contrast = "hard"`, `bg0` for `"medium"`, `bg0_s` for `"soft"` |
| `fg`     | `fg1` |
| `accent` | the bright color named by `gruvbox.accent` |

Modules use `bg`, `fg` and `accent` wherever a program has a single background,
foreground or highlight, which is how `contrast` and `accent` reach every
program at once.

### Formats

| option            | example value for `orange` | for |
|-------------------|----------------------------|-----|
| `gruvbox.palette` | `"#fe8019"`                | most config files |
| `gruvbox.rgb`     | `"254, 128, 25"`           | CSS `rgba(254, 128, 25, 0.5)` |
| `gruvbox.ansi`    | `"254;128;25"`             | terminal escapes `\e[38;2;254;128;25m` |

### Using the palette in your own config

Anything without a module can still read the palette:

```nix
{ config, ... }:
let
  p = config.gruvbox.palette;
in
{
  programs.foot.settings.colors = {
    background = builtins.substring 1 6 p.bg;
    foreground = builtins.substring 1 6 p.fg;
  };

  programs.waybar.style = ''
    window#waybar { background: rgba(${config.gruvbox.rgb.bg}, 0.9); color: ${p.fg}; }
    #workspaces button.active { color: ${p.accent}; }
  '';

  programs.fastfetch.settings.modules = [
    { type = "os"; keyColor = "38;2;${config.gruvbox.ansi.red}"; }
  ];
}
```

### Outside the module system

`lib.palette` is a pure function with no dependency on nixpkgs, for scripts,
overlays or other flakes:

```nix
inputs.gruvbox.lib.palette { flavor = "dark"; contrast = "hard"; accent = "aqua"; }
# => { bg = "#1d2021"; accent = "#8ec07c"; red = "#fb4934"; ... }

inputs.gruvbox.lib.hexToRgb ";" "#fe8019"
# => "254;128;25"
```

All three arguments are optional and default to `dark`, `medium`, `orange`.

## Overriding

Every value a module sets goes through `lib.mkDefault` on the leaf, so a plain
definition in your config wins without `mkForce`:

```nix
gruvbox.enable = true;

# keep gruvbox everywhere, but a purple border instead of the accent
programs.niri.settings.layout.border.active.color = config.gruvbox.palette.purple;

# keep gruvbox's alacritty colors, but a different cursor
programs.alacritty.settings.colors.cursor.cursor = config.gruvbox.palette.yellow;
```

If you want a whole program left alone, disable its module rather than
overriding every key:

```nix
gruvbox.starship.enable = false;
```

## Adding a module

One file per program under `modules/home-manager/` or `modules/nixos/`. The
shape is always the same:

```nix
# modules/home-manager/foo.nix
{ config, lib, ... }:

let
  cfg = config.gruvbox.foo;
  p = config.gruvbox.palette;
in
{
  options.gruvbox.foo.enable =
    lib.mkEnableOption "gruvbox for foo" // { default = config.gruvbox.enable; };

  config = lib.mkIf cfg.enable {
    programs.foo.settings.colors = lib.mapAttrsRecursive (_: lib.mkDefault) {
      background = p.bg;
      foreground = p.fg;
      accent = p.accent;
    };
  };
}
```

Rules, all of which the existing modules follow:

1. `gruvbox.<name>.enable` is the only option, and defaults to the global switch.
2. Set values with `lib.mkDefault` on every leaf. Not on a whole attrset: the
   module system resolves priority per option, so a default on the parent is
   all-or-nothing against a user definition. `lib.mapAttrsRecursive (_: lib.mkDefault)`
   does the leaves for you.
3. If home-manager already defines defaults for the same keys with `mkDefault`
   (dircolors does), use `lib.mkOverride 900` instead so yours win and the
   user's still win over yours.
4. Only touch options the program's own module declares. Never create config
   files by hand when `programs.foo.settings` exists.
5. If the options come from another flake, guard the body with
   `lib.optionalAttrs (options.programs ? foo)` and take `options` as a module
   argument. `lib.mkIf false` is not enough: it still declares the option path
   and fails evaluation when the program's module is absent.
6. Use `bg`, `fg` and `accent` for the program's main background, foreground and
   highlight so `contrast` and `accent` apply. Use the named colors for
   everything else.
7. Add the file to `modules/home-manager/default.nix` (or `modules/nixos/default.nix`),
   enable the program in the `hm` check in `flake.nix`, and add one assertion
   there for a value the module sets.
8. `nix flake check`.

Commit as `feat(foo): what it sets`.

## Checks

`nix flake check` runs three things:

| check     | what |
|-----------|------|
| `palette` | unit test for the palette table and `hexToRgb` (`lib/test.nix`) |
| `hm`      | builds a home-manager configuration with `gruvbox.enable = true` and every themable program enabled, with assertions on the generated values |
| `nixos`   | evaluates a NixOS configuration with the NixOS module and asserts the palette |

Modules whose options come from external flakes (niri, noctalia,
noctalia-greeter) are no-ops inside these checks. They are verified by building
a real system that imports those flakes.

CI runs the same command on every push and pull request, and weekly to catch
nixpkgs and home-manager drift.

## FAQ

**Why generate everything instead of fetching upstream gruvbox ports like
catppuccin/nix does?**
Catppuccin maintains an official port for nearly every program, so their flake
can pin and import those files. gruvbox has no such organization: ports are
scattered, unmaintained, and disagree with each other. Generating from one
palette in Nix means one source of truth, `contrast` and `accent` work
everywhere, and there is nothing to keep in sync.

**Does importing the flake change anything before I set `gruvbox.enable`?**
No. Every module is `mkIf cfg.enable`, and `cfg.enable` defaults to
`gruvbox.enable`, which defaults to `false`.

**Why did my terminal not change contrast?**
Programs with a built-in theme name and no per-color options (zellij) can only
pick dark or light. Programs with full color options (alacritty) follow
`contrast`.

**Can I use a different accent per program?**
Set the value directly; it overrides the module's default:
`programs.niri.settings.layout.border.active.color = config.gruvbox.palette.aqua;`

**A program I use has no module.**
Read `config.gruvbox.palette` in your own config
(see [above](#using-the-palette-in-your-own-config)), or
[add a module](#adding-a-module) and open a pull request.

**Which nixpkgs and home-manager versions work?**
The flake is developed and checked against `nixos-unstable` and home-manager
master. Modules only use long-stable options, so release branches should work,
but they are not in CI.

## License

MIT.
