{ inputs, ... }:
{
  programs.plasma = {
    enable = true;
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      cursor = {
        theme = "Bibata-Modern-Ice";
        size = 24;
      };
      wallpaper = "${inputs.background-img}";
    };
    configFile = {
      "kcminputrc"."Libinput/4152/5929/SteelSeries SteelSeries Rival 110 Gaming Mouse"."PointerAcceleration" = "-0.600";
      "kdeglobals"."KScreen"."ScaleFactor" = 1.5;
      "kwinrc"."Xwayland"."Scale" = 1.5;
      "kscreenlockerrc"."Greeter/Wallpaper/org.kde.image/General"."Image" = "${inputs.background-img}";
      "kscreenlockerrc"."Greeter/Wallpaper/org.kde.image/General"."PreviewImage" = "${inputs.background-img}";
    };
  };
}
