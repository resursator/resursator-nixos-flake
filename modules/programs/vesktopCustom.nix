{
  lib,
  config,
  pkgs,
  ...
}:
let
  customVesktopIcon = pkgs.runCommand "custom-vesktop-icon" {} ''
    mkdir -p $out
    cp ${../../resources/discord.png} $out/icon.png
    cp ${../../resources/discord-tray-icon.png} $out/tray-icon.png
    cp ${../../resources/discord-loading.gif} $out/loading.gif
  '';

  vesktopCustom = pkgs.vesktop.overrideAttrs (oldAttrs: {
    preBuild = oldAttrs.preBuild or "" + ''
      echo "Replacing tray icon and loading animation"
      cp ${customVesktopIcon}/tray-icon.png build/icon.png
      cp ${customVesktopIcon}/tray-icon.png static/icon.png
      cp ${customVesktopIcon}/loading.gif static/shiggy.gif
    '';
    postInstall = oldAttrs.postInstall or "" + ''
      echo "Replacing app icon"
      rm -r $out/share/icons/hicolor
      mkdir -p $out/share/icons/hicolor/256x256/apps/

      # Ensure the icon directory exists
      iconPath="$out/share/icons/hicolor/256x256/apps/vesktop.png"

      # Copy the custom icon (replace with your actual icon file)
      cp ${customVesktopIcon}/icon.png $iconPath
    '';
  });
in
{
  options = {
    vesktopCustom.enable = lib.mkEnableOption "enables vesktop with custom icon";
  };

  config = lib.mkIf config.vesktopCustom.enable {
    environment.systemPackages = [
      vesktopCustom
    ];
  };
}
