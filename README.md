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

Every module also takes its own `flavor`, `contrast` and `accent`, defaulting
to the global ones, so one program can differ from the rest:

```nix
gruvbox.enable = true;
gruvbox.flavor = "dark";
gruvbox.kitty.flavor = "light";  # light terminal, dark everything else
gruvbox.niri.accent = "purple";  # purple borders, orange everywhere else
```

| option                       | default            |
|------------------------------|--------------------|
| `gruvbox.<module>.enable`    | `gruvbox.enable`   |
| `gruvbox.<module>.flavor`    | `gruvbox.flavor`   |
| `gruvbox.<module>.contrast`  | `gruvbox.contrast` |
| `gruvbox.<module>.accent`    | `gruvbox.accent`   |

## Modules

A module maps the palette onto one program's existing home-manager or NixOS
options. It never writes files a program would not read anyway and never
installs the program itself.

### home-manager modules

| module      | sets                                                                 | needs |
|-------------|----------------------------------------------------------------------|-------|
| `alacritty` | `programs.alacritty.settings.colors` (primary, normal, bright)       | `programs.alacritty.enable` |
| `bat`       | `programs.bat.config.theme = "gruvbox-dark"` or `"gruvbox-light"` (built in) | `programs.bat.enable` |
| `bottom`    | `programs.bottom.settings.styles.colors`                             | `programs.bottom.enable` |
| `btop`      | `programs.btop.settings.color_theme = "gruvbox_dark"` or `"gruvbox_light"` (built in) | `programs.btop.enable` |
| `cava`      | `programs.cava.settings.color`: seven-stop gradient green to aqua    | `programs.cava.enable` |
| `delta`     | `programs.delta.options`: bat syntax theme, minus/plus styles, line numbers, file and hunk headers | `programs.delta.enable` |
| `dircolors` | `programs.dircolors.settings` (LS_COLORS for ls, grep, fd, eza)      | `programs.dircolors.enable` |
| `doom`      | `~/.config/doom/gruvbox.el`: `doom-theme` by flavor and contrast, mode-line and dired faces | doom emacs, see [notes](#doom) |
| `dunst`     | `services.dunst.settings`: frame color, low/normal/critical urgency colors | `services.dunst.enable` |
| `eza`       | `home.sessionVariables.EZA_COLORS`                                   | nothing |
| `fastfetch` | `programs.fastfetch.settings.display.color` (keys, title, separator) | `programs.fastfetch.enable` |
| `fish`      | `fish_color_*` and `fish_pager_color_*` via `interactiveShellInit`   | `programs.fish.enable` |
| `foot`      | `programs.foot.settings.colors`                                      | `programs.foot.enable` |
| `fuzzel`    | `programs.fuzzel.settings.colors`                                    | `programs.fuzzel.enable` |
| `fzf`       | `programs.fzf.colors`                                                | `programs.fzf.enable` |
| `gh-dash`   | `programs.gh-dash.settings.theme.colors`                             | `programs.gh-dash.enable` |
| `ghostty`   | `programs.ghostty.settings`: background, foreground, cursor, selection, palette | `programs.ghostty.enable` |
| `gitui`     | `programs.gitui.theme` (full ron theme)                              | `programs.gitui.enable` |
| `gtk`       | `gtk.theme` Gruvbox-Dark/Light, `gtk.iconTheme` Gruvbox-Plus-Dark/Light, `gtk.colorScheme`, dconf `color-scheme` | nothing (sets `gtk.enable`) |
| `helix`     | `programs.helix.settings.theme` from the six built-in gruvbox themes, flavor and contrast honored | `programs.helix.enable` |
| `hyprland`  | `general.col.active_border` / `col.inactive_border`, `misc.background_color`, `decoration.shadow.color`, plus `$gruvbox_<key>` variables | `wayland.windowManager.hyprland.enable` |
| `hyprlock`  | `$gruvbox_<key>` variables in `programs.hyprlock.settings`, see [notes](#hyprlock-and-waybar) | `programs.hyprlock.enable` |
| `imv`       | `programs.imv.settings.options`: background, overlay colors          | `programs.imv.enable` |
| `k9s`       | `programs.k9s.skins.gruvbox` (full skin) and `settings.k9s.ui.skin`  | `programs.k9s.enable` |
| `kitty`     | `programs.kitty.settings`: colors, cursor, selection, borders, tabs  | `programs.kitty.enable` |
| `lazygit`   | `programs.lazygit.settings.gui.theme`                                | `programs.lazygit.enable` |
| `lsd`       | `programs.lsd.colors`: user, group, permissions, dates, sizes, git status | `programs.lsd.enable` |
| `mako`      | `services.mako.settings`: background, text, border, progress, urgency sections | `services.mako.enable` |
| `mangohud`  | `programs.mangohud.settings`: text, background and per-stat colors   | `programs.mangohud.enable` |
| `mpv`       | `programs.mpv.config`: osd and subtitle colors                        | `programs.mpv.enable` |
| `neovim`    | adds `vimPlugins.gruvbox-nvim`, sets background, contrast and colorscheme in `extraLuaConfig` | `programs.neovim.enable` |
| `niri`      | `programs.niri.settings.layout`: background, active and inactive border, shadow | [niri-flake](https://github.com/sodiboo/niri-flake) module imported |
| `noctalia`  | `programs.noctalia-shell.colors` (material slots) and `settings.colorSchemes` | [noctalia](https://github.com/noctalia-dev/noctalia) module imported |
| `nushell`   | `$env.config.color_config` via `programs.nushell.extraConfig`         | `programs.nushell.enable` |
| `qt`        | dark: qtct platform theme, kvantum style, Gruvbox-Dark-Brown kvantum theme. light: gtk platform theme | nothing (sets `qt.enable`) |
| `qutebrowser` | `programs.qutebrowser.settings.colors`: completion, statusbar, tabs, hints, prompts, messages, downloads, context menu | `programs.qutebrowser.enable` |
| `rio`       | `programs.rio.settings.colors`                                       | `programs.rio.enable` |
| `rofi`      | `programs.rofi.theme`: global background/text/border, selected and urgent elements | `programs.rofi.enable` |
| `sioyek`    | `programs.sioyek.config`: background, text, highlight, ui and status bar colors | `programs.sioyek.enable` |
| `skim`      | `--color=...` in `programs.skim.defaultOptions`                      | `programs.skim.enable` |
| `spotify-player` | a `gruvbox` entry in `programs.spotify-player.themes` and `settings.theme` | `programs.spotify-player.enable` |
| `starship`  | `programs.starship.settings.palette = "gruvbox"` and `palettes.gruvbox` | `programs.starship.enable` |
| `sway`      | `wayland.windowManager.sway.config.colors`: focused, focusedInactive, unfocused, urgent, placeholder, background | `wayland.windowManager.sway.enable` |
| `swaylock`  | `programs.swaylock.settings`: ring, inside, key highlight, verify/wrong/clear states | `programs.swaylock.enable` |
| `tmux`      | status bar, pane borders, messages, copy mode via `programs.tmux.extraConfig` | `programs.tmux.enable` |
| `vivid`     | `programs.vivid.activeTheme` from the six built-in gruvbox themes, flavor and contrast honored | `programs.vivid.enable` |
| `vscode`    | adds `vscode-extensions.jdinhlife.gruvbox` to the default profile and sets `workbench.colorTheme` by flavor and contrast | `programs.vscode.enable` |
| `waybar`    | `@define-color gruvbox_<key>` for every palette key, prepended to `programs.waybar.style`, see [notes](#hyprlock-and-waybar) | `programs.waybar.enable` |
| `wezterm`   | `programs.wezterm.colorSchemes.gruvbox` and `settings.color_scheme`  | `programs.wezterm.enable` |
| `zathura`   | `programs.zathura.options`: page, statusbar, inputbar, completion, index, notification and recolor colors | `programs.zathura.enable` |
| `zellij`    | `programs.zellij.settings.theme = "gruvbox-dark"` or `"gruvbox-light"` (built in) | `programs.zellij.enable` |
| `zsh`       | `programs.zsh.syntaxHighlighting.styles`                             | `programs.zsh.syntaxHighlighting.enable` |

### NixOS modules

| module             | sets                                                                     | needs |
|--------------------|--------------------------------------------------------------------------|-------|
| `console`          | `console.colors`: the 16 tty colors                                      | nothing |
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

#### zellij, bat, btop, vivid

These ship gruvbox themes of their own, and the modules point at those by
name. zellij, bat and btop only have dark and light, so `contrast` has no
effect on them; vivid has all six variants.

#### helix

Helix ships all six variants, so flavor and contrast both apply:

| flavor | hard                 | medium          | soft                 |
|--------|----------------------|-----------------|----------------------|
| dark   | `gruvbox_dark_hard`  | `gruvbox`       | `gruvbox_dark_soft`  |
| light  | `gruvbox_light_hard` | `gruvbox_light` | `gruvbox_light_soft` |

#### hyprlock and waybar

Both are styled by config you write yourself (hyprlock's elements are lists,
waybar's style is free-form CSS), so the modules define named colors instead of
overwriting your layout:

```css
/* waybar style.css */
#workspaces button.active { color: @gruvbox_accent; background: @gruvbox_bg1; }
```

```
# hyprlock.conf via programs.hyprlock.settings
input-field { outer_color = $gruvbox_accent; inner_color = $gruvbox_bg1; font_color = $gruvbox_fg; }
```

Every palette key exists as `@gruvbox_<key>` (waybar) and `$gruvbox_<key>`
(hyprlock, hyprland). Hyprland also gets its borders, background and shadow set
directly.

#### vscode and neovim

These two install a theme rather than generate one: the `jdinhlife.gruvbox`
extension and the `gruvbox.nvim` plugin, both from nixpkgs. The module then
selects the variant matching `flavor` and `contrast`. For neovim the setup
lines go in with `mkBefore`, so a `colorscheme` call in your own lua wins.

#### tmux

tmux has no color options in home-manager, so the module writes `set -g` lines
into `programs.tmux.extraConfig` with `mkBefore`. tmux keeps the last value it
reads, so any `set -g status-style` in your own `extraConfig` wins.

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

One file per program under `modules/home-manager/` or `modules/nixos/`. Files
are picked up automatically; there is nothing to register. The shape is always
the same:

```nix
# modules/home-manager/foo.nix
{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.foo;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.foo = gl.mkModule "foo";

  config = lib.mkIf cfg.enable {
    programs.foo.settings.colors = gl.mkDefaults {
      background = p.bg;
      foreground = p.fg;
      accent = p.accent;
    };
  };
}
```

`modules/lib.nix` gives every module the same toolkit:

| helper               | what |
|----------------------|------|
| `gl.mkModule name`   | the `enable`, `flavor`, `contrast`, `accent` options, defaulting to the globals |
| `gl.paletteOf cfg`   | the palette for this module's own flavor, contrast and accent |
| `gl.ansiOf cfg`      | same, as `R;G;B` strings |
| `gl.term16 p`        | the 16 ANSI colors in order, for terminals |
| `gl.mkDefaults attrs`| `lib.mkDefault` on every leaf |
| `gl.fg rgb`          | `38;2;R;G;B` |
| `gl.noHash hex`      | `#rrggbb` to `rrggbb` |
| `gl.hasOpt path`     | whether an option path exists, for programs from other flakes |

Rules, all of which the existing modules follow:

1. `gl.mkModule` declares the options; read `cfg.flavor` / `cfg.contrast` and
   `gl.paletteOf cfg`, never `config.gruvbox.palette`, so per-module overrides
   work.
2. Set values with `lib.mkDefault` on every leaf, which `gl.mkDefaults` does.
   Not on a whole attrset: the module system resolves priority per option, so a
   default on the parent is all-or-nothing against a user definition.
3. If home-manager already defines defaults for the same keys with `mkDefault`
   (dircolors does), use `lib.mkOverride 900` so yours win and the user's still
   win over yours.
4. Only touch options the program's own module declares. Never create config
   files by hand when `programs.foo.settings` exists.
5. If the options come from another flake, guard the body with
   `lib.optionalAttrs (gl.hasOpt [ "programs" "foo" ])`. `lib.mkIf false` is
   not enough: it still declares the option path and fails evaluation when the
   program's module is absent.
6. If the program ships its own gruvbox theme, point at it by name (zellij,
   bat, btop, helix) instead of generating one.
7. Use `bg`, `fg` and `accent` for the program's main background, foreground
   and highlight so `contrast` and `accent` apply. Use the named colors for
   everything else.
8. Enable the program in `checks/hm.nix` and add one `[ actual expected ]`
   pair to `expect` in `flake.nix`.
9. `nix flake check`.

Commit as `feat(foo): what it sets`.

## Checks

`nix flake check` runs two checks, both evaluation only. Nothing is built, so
adding modules never makes CI slower.

| check     | what |
|-----------|------|
| `palette` | unit test for the palette table and `hexToRgb` (`lib/test.nix`) |
| `modules` | evaluates a home-manager configuration (`checks/hm.nix`) with every themable program enabled and per-module overrides set, plus the NixOS module, and compares generated values against `expect` in `flake.nix` |

Modules whose options come from external flakes (niri, noctalia,
noctalia-greeter) are no-ops inside these checks. They are verified by building
a real system that imports those flakes.

CI runs the same command on every push and pull request, and weekly to catch
nixpkgs and home-manager drift.

## License

MIT.
