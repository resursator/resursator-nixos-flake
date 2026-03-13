{
  lib,
  config,
  pkgs,
  ...
}:
let
  customVesktopIcon = pkgs.runCommand "custom-vesktop-icon" { } ''
    mkdir -p $out
    cp ${../../resources/discord/discord.icns} $out/icon.icns
    cp ${../../resources/discord/discord.ico} $out/icon.ico
    cp ${../../resources/discord/discord.svg} $out/icon.svg
    cp ${../../resources/discord/discord-tray-icon.png} $out/tray-icon.png
    cp ${../../resources/discord/discord-tray-icon-unread.png} $out/tray-icon-unread.png
    cp ${../../resources/discord/discord-loading.webp} $out/loading.webp
  '';

  vesktopCustom = pkgs.vesktop.overrideAttrs (oldAttrs: {
    preBuild = oldAttrs.preBuild or "" + ''
      echo "Replacing icon, icns and loading animation"
      cp ${customVesktopIcon}/icon.icns build/icon.icns
      cp ${customVesktopIcon}/icon.svg build/icon.svg
      cp ${customVesktopIcon}/icon.ico build/icon.ico
      cp ${customVesktopIcon}/loading.webp static/splash.webp
      cp ${customVesktopIcon}/tray-icon.png static/tray.png
      cp ${customVesktopIcon}/tray-icon.png static/tray/tray.png
      cp ${customVesktopIcon}/tray-icon-unread.png static/tray/trayUnread.png
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
