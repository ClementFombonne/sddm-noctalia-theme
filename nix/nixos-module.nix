{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.services.displayManager.sddm.noctalia;

  # Helper to convert booleans to strings for the INI file
  toSddmVal = v: if builtins.isBool v then (if v then "true" else "false") else toString v;

  # Handle Background Path
  bgFileName = if cfg.background != null then builtins.baseNameOf cfg.background else "noctalia.png";
  bgConfigValue = "Assets/Wallpaper/${bgFileName}";

  # Configuration logic for theme.conf
  finalThemeConfig = {
    General = {
      background = bgConfigValue;
      colorScheme = cfg.colorScheme;
      darkMode = toSddmVal cfg.darkMode;
      hideShadow = toSddmVal cfg.hideShadow;
      fontFamily = cfg.fontFamily;
      clockStyle = cfg.clockStyle;

      # Scaling
      fontScale = toSddmVal cfg.scaling.font;
      radiusRatio = toSddmVal cfg.scaling.radius;
      iRadiusRatio = toSddmVal cfg.scaling.iRadius;
      screenRadiusRatio = toSddmVal cfg.scaling.screenRadius;
      scaleRatio = toSddmVal cfg.scaling.scale;
      animationSpeed = toSddmVal cfg.scaling.animationSpeed;
    }
    // cfg.extraSettings;
  };

  # Dependencies required by QML at runtime
  themeDependencies = with pkgs.kdePackages; [
    qt6ct
    qtsvg
    qtwayland
    qtdeclarative
  ];

in
{
  options.services.displayManager.sddm.noctalia = with lib; {
    enable = mkEnableOption "Noctalia SDDM Theme";

    background = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to a custom wallpaper. If null, uses the default theme wallpaper.";
    };

    colorScheme = mkOption {
      type = types.str;
      default = "Noctalia-default";
      description = "ColorScheme selector.";
    };

    darkMode = mkOption {
      type = types.bool;
      default = true;
      description = "Enable DarkMode.";
    };

    hideShadow = mkOption {
      type = types.bool;
      default = false;
      description = "Hide background shadow.";
    };

    fontFamily = mkOption {
      type = types.str;
      default = "Roboto";
      description = "Font family used in the interface.";
    };

    clockStyle = mkOption {
      type = types.enum [
        "digital"
        "analog"
      ];
      default = "digital";
      description = "Clock widget style.";
    };

    scaling = {
      font = mkOption {
        type = types.float;
        default = 1.0;
        description = "Scale factor applied to interface font sizes.";
      };
      radius = mkOption {
        type = types.float;
        default = 1.0;
        description = "Global scale factor for rounded corner radius of UI elements.";
      };
      iRadius = mkOption {
        type = types.float;
        default = 1.0;
        description = "Scale factor for inner radii, such as internal borders or shapes.";
      };
      screenRadius = mkOption {
        type = types.float;
        default = 1.0;
        description = "Scale factor for corner radius relative to the screen edges.";
      };
      scale = mkOption {
        type = types.float;
        default = 1.0;
        description = "Overall UI scaling multiplier for the theme components.";
      };
      animationSpeed = mkOption {
        type = types.float;
        default = 1.0;
        description = "Multiplier for animation speed (values > 1.0 are faster, < 1.0 are slower).";
      };
    };

    extraSettings = mkOption {
      type = types.attrs;
      default = { };
      description = "Extra settings to merge into theme.conf";
    };
  };

  config = lib.mkIf cfg.enable {
    # Clear cache script (useful for development/updates)
    system.activationScripts.clearSddmCache = {
      text = ''
        if [ -d /var/lib/sddm/.cache ]; then
          rm -rf /var/lib/sddm/.cache
        fi
      '';
    };

    services.displayManager.sddm = {
      enable = true;
      package = pkgs.kdePackages.sddm;
      theme = "noctalia-sddm";
      extraPackages = themeDependencies;
    };

    environment.systemPackages = [
      (pkgs.stdenv.mkDerivation {
        name = "noctalia-sddm";

        # Use the local source (the root of your git repo)
        src = lib.cleanSource ../.;

        installPhase = ''
          mkdir -p $out/share/sddm/themes/noctalia-sddm
          cp -r Assets Commons Helpers Widgets $out/share/sddm/themes/noctalia-sddm
          cp Main.qml metadata.desktop qmldir $out/share/sddm/themes/noctalia-sddm

          # Copy custom background if provided
          ${lib.optionalString (cfg.background != null) ''
            mkdir -p $out/share/sddm/themes/noctalia-sddm/Assets/Wallpaper
            cp ${cfg.background} $out/share/sddm/themes/noctalia-sddm/Assets/Wallpaper/${bgFileName}
          ''}

          # Generate the customized theme.conf
          rm -f $out/share/sddm/themes/noctalia-sddm/Commons/Settings.conf
          cp ${pkgs.writeText "theme.conf" (lib.generators.toINI { } finalThemeConfig)} \
             $out/share/sddm/themes/noctalia-sddm/Commons/Settings.conf
        '';
      })
    ];
  };
}
