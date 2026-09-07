{ pkgs, ... }:

{
  home.username = "check";
  home.homeDirectory = "/home/check";
  home.stateVersion = "26.05";

  gruvbox.enable = true;
  gruvbox.contrast = "hard";
  gruvbox.accent = "yellow";
  gruvbox.alacritty.accent = "aqua";
  gruvbox.zellij.flavor = "light";
  gruvbox.kitty.accent = "purple";
  gruvbox.helix.flavor = "light";

  programs.alacritty.enable = true;
  programs.zellij.enable = true;
  programs.fish.enable = true;
  programs.dircolors.enable = true;
  programs.fastfetch.enable = true;
  programs.starship.enable = true;
  gtk.enable = true;
  qt.enable = true;

  programs.kitty.enable = true;
  programs.foot.enable = true;
  programs.ghostty.enable = true;
  programs.wezterm.enable = true;

  programs.fzf.enable = true;
  programs.tmux.enable = true;
  programs.lazygit.enable = true;
  programs.delta.enable = true;
  programs.btop.enable = true;
  programs.bat.enable = true;
  programs.helix.enable = true;
  programs.cava.enable = true;

  programs.waybar.enable = true;
  programs.rofi.enable = true;
  programs.fuzzel.enable = true;
  services.dunst.enable = true;
  services.mako.enable = true;
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.sway.enable = true;
  programs.hyprlock.enable = true;
  programs.swaylock.enable = true;

  programs.vscode = { enable = true; package = pkgs.vscodium; };
  programs.neovim.enable = true;
  programs.zathura.enable = true;
  programs.mpv.enable = true;
  programs.k9s.enable = true;
  programs.bottom.enable = true;
  programs.qutebrowser.enable = true;
  programs.sioyek.enable = true;
  programs.imv.enable = true;
  programs.rio.enable = true;
}
