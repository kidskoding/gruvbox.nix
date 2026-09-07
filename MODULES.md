# Modules

Every module is `gruvbox.<name>.enable`, on by default when `gruvbox.enable`
is, with its own `flavor`, `contrast` and `accent`. See the README for the
options and the palette.

A module maps the palette onto one program's existing home-manager or NixOS
options. It never writes files a program would not read anyway and never
installs the program itself.

## home-manager modules

| module      | sets                                                                 | needs |
|-------------|----------------------------------------------------------------------|-------|
| `aerc`      | a `gruvbox` styleset in `programs.aerc.stylesets` and `ui.styleset-name` | `programs.aerc.enable` |
| `alacritty` | `programs.alacritty.settings.colors` (primary, normal, bright)       | `programs.alacritty.enable` |
| `atuin`     | a `gruvbox` entry in `programs.atuin.themes` and `settings.theme.name` | `programs.atuin.enable` |
| `bat`       | `programs.bat.config.theme = "gruvbox-dark"` or `"gruvbox-light"` (built in) | `programs.bat.enable` |
| `bottom`    | `programs.bottom.settings.styles.colors`                             | `programs.bottom.enable` |
| `broot`     | `programs.broot.settings.skin` (full skin)                           | `programs.broot.enable` |
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
| `halloy`    | a `gruvbox` entry in `programs.halloy.themes` and `settings.theme`    | `programs.halloy.enable` |
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
| `micro`     | `programs.micro.settings.colorscheme = "gruvbox-tc"` (built in, dark only) | `programs.micro.enable` |
| `mpv`       | `programs.mpv.config`: osd and subtitle colors                        | `programs.mpv.enable` |
| `neovim`    | adds `vimPlugins.gruvbox-nvim`, sets background, contrast and colorscheme in `extraLuaConfig` | `programs.neovim.enable` |
| `niri`      | `programs.niri.settings.layout`: background, active and inactive border, shadow | [niri-flake](https://github.com/sodiboo/niri-flake) module imported |
| `noctalia`  | `programs.noctalia-shell.colors` (material slots) and `settings.colorSchemes` | [noctalia](https://github.com/noctalia-dev/noctalia) module imported |
| `nushell`   | `$env.config.color_config` via `programs.nushell.extraConfig`         | `programs.nushell.enable` |
| `opencode`  | `programs.opencode.settings.theme = "gruvbox"` (built in)            | `programs.opencode.enable` |
| `polybar`   | a `[colors]` section with every palette key in `services.polybar.settings`; use `${colors.accent}` | `services.polybar.enable` |
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
| `swaync`    | `@define-color gruvbox_<key>` prepended to `services.swaync.style`   | `services.swaync.enable` |
| `television` | a `gruvbox` entry in `programs.television.themes` and `settings.ui.theme` | `programs.television.enable` |
| `tmux`      | status bar, pane borders, messages, copy mode via `programs.tmux.extraConfig` | `programs.tmux.enable` |
| `tofi`      | `programs.tofi.settings`: background, text, prompt, selection, border | `programs.tofi.enable` |
| `vivid`     | `programs.vivid.activeTheme` from the six built-in gruvbox themes, flavor and contrast honored | `programs.vivid.enable` |
| `vscode`    | adds `vscode-extensions.jdinhlife.gruvbox` to the default profile and sets `workbench.colorTheme` by flavor and contrast | `programs.vscode.enable` |
| `waybar`    | `@define-color gruvbox_<key>` for every palette key, prepended to `programs.waybar.style`, see [notes](#hyprlock-and-waybar) | `programs.waybar.enable` |
| `wezterm`   | `programs.wezterm.colorSchemes.gruvbox` and `settings.color_scheme`  | `programs.wezterm.enable` |
| `wleave`    | `@define-color gruvbox_<key>` prepended to `programs.wleave.style`   | `programs.wleave.enable` |
| `wlogout`   | `@define-color gruvbox_<key>` prepended to `programs.wlogout.style`  | `programs.wlogout.enable` |
| `yazi`      | `programs.yazi.theme`: manager, mode, status, pickers, input, tasks, which, help, notify, confirm, spot | `programs.yazi.enable` |
| `zathura`   | `programs.zathura.options`: page, statusbar, inputbar, completion, index, notification and recolor colors | `programs.zathura.enable` |
| `zed-editor` | `programs.zed-editor.userSettings.theme` from the six built-in gruvbox themes, flavor and contrast honored | `programs.zed-editor.enable` |
| `zellij`    | `programs.zellij.settings.theme = "gruvbox-dark"` or `"gruvbox-light"` (built in) | `programs.zellij.enable` |
| `zsh`       | `programs.zsh.syntaxHighlighting.styles`                             | `programs.zsh.syntaxHighlighting.enable` |

## NixOS modules

| module             | sets                                                                     | needs |
|--------------------|--------------------------------------------------------------------------|-------|
| `console`          | `console.colors`: the 16 tty colors                                      | nothing |
| `noctalia-greeter` | `programs.noctalia-greeter.settings.appearance`: `scheme = "Synced"`, `theme_mode`, full `palette` | [noctalia-greeter](https://github.com/noctalia-dev/noctalia-greeter) module imported |

## Module notes

### doom

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

### zellij, bat, btop, vivid, micro, opencode

These ship gruvbox themes of their own, and the modules point at those by
name. zellij, bat and btop only have dark and light, so `contrast` has no
effect on them; micro and opencode only have dark; vivid has all six variants.

### helix

Helix ships all six variants, so flavor and contrast both apply:

| flavor | hard                 | medium          | soft                 |
|--------|----------------------|-----------------|----------------------|
| dark   | `gruvbox_dark_hard`  | `gruvbox`       | `gruvbox_dark_soft`  |
| light  | `gruvbox_light_hard` | `gruvbox_light` | `gruvbox_light_soft` |

### hyprlock, waybar, swaync, wlogout, wleave, polybar

These are styled by config you write yourself (hyprlock's elements are lists,
the others take free-form CSS or ini), so the modules define named colors
instead of overwriting your layout:

```css
/* waybar style.css */
#workspaces button.active { color: @gruvbox_accent; background: @gruvbox_bg1; }
```

```
# hyprlock.conf via programs.hyprlock.settings
input-field { outer_color = $gruvbox_accent; inner_color = $gruvbox_bg1; font_color = $gruvbox_fg; }
```

Every palette key exists as `@gruvbox_<key>` (waybar, swaync, wlogout,
wleave), `$gruvbox_<key>` (hyprlock, hyprland) and `${colors.<key>}` (polybar).
Hyprland also gets its borders, background and shadow set directly.

### vscode and neovim

These two install a theme rather than generate one: the `jdinhlife.gruvbox`
extension and the `gruvbox.nvim` plugin, both from nixpkgs. The module then
selects the variant matching `flavor` and `contrast`. For neovim the setup
lines go in with `mkBefore`, so a `colorscheme` call in your own lua wins.

### tmux

tmux has no color options in home-manager, so the module writes `set -g` lines
into `programs.tmux.extraConfig` with `mkBefore`. tmux keeps the last value it
reads, so any `set -g status-style` in your own `extraConfig` wins.

### qt

nixpkgs only packages a dark kvantum theme (`gruvbox-kvantum`,
Gruvbox-Dark-Brown). With `flavor = "light"` the module sets
`qt.platformTheme.name = "gtk"` so Qt follows the gtk theme instead.

### dircolors

home-manager ships its own defaults for `programs.dircolors.settings`, so the
module sets its values at priority 900: above home-manager's `mkDefault`, still
below anything you write yourself.

### niri, noctalia, noctalia-greeter

These programs' options come from other flakes. The modules check whether the
option tree exists and become no-ops when it does not, so importing
`gruvbox.nix` never fails on a machine without niri or noctalia.
