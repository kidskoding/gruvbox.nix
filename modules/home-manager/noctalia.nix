{ config, lib, options, ... }:

let
  cfg = config.gruvbox.noctalia;
  p = config.gruvbox.palette;
in
{
  options.gruvbox.noctalia.enable =
    lib.mkEnableOption "gruvbox for noctalia-shell" // { default = config.gruvbox.enable; };

  # no-op unless noctalia's home-manager module is imported
  config = lib.mkIf cfg.enable (lib.optionalAttrs (options.programs ? noctalia-shell) {
    programs.noctalia-shell = {
      colors = lib.mapAttrs (_: lib.mkDefault) {
        mPrimary = p.accent;        mOnPrimary = p.bg;
        mSecondary = p.purple;      mOnSecondary = p.bg;
        mTertiary = p.green;        mOnTertiary = p.bg;
        mError = p.red;             mOnError = p.bg;
        mSurface = p.bg;            mOnSurface = p.fg;
        mSurfaceVariant = p.bg1;    mOnSurfaceVariant = p.fg4;
        mOutline = p.bg2;
        mShadow = p.bg0_h;
        mHover = p.fg;              mOnHover = p.bg;
      };

      settings.colorSchemes = {
        useWallpaperColors = lib.mkDefault false;
        predefinedScheme = lib.mkDefault "";
        darkMode = lib.mkDefault (config.gruvbox.flavor == "dark");
        # gtk.nix owns gsettings
        syncGsettings = lib.mkDefault false;
      };
    };
  });
}
