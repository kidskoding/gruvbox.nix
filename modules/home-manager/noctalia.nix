{ config, lib, options, ... }:

let
  gl = import ../lib.nix { inherit config lib options; };
  cfg = config.gruvbox.noctalia;
  p = gl.paletteOf cfg;
in
{
  options.gruvbox.noctalia = gl.mkModule "noctalia";

  # no-op unless noctalia's home-manager module is imported
  config = lib.mkIf cfg.enable (lib.optionalAttrs (gl.hasOpt [ "programs" "noctalia-shell" ]) {
    programs.noctalia-shell = {
      colors = gl.mkDefaults {
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

      settings.colorSchemes = gl.mkDefaults {
        useWallpaperColors = false;
        predefinedScheme = "";
        darkMode = cfg.flavor == "dark";
        # gtk.nix owns gsettings
        syncGsettings = false;
      };
    };
  });
}
