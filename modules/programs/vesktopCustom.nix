{
  lib,
  config,
  pkgs,
  ...
}:
let
  customVesktopIcon = pkgs.runCommand "custom-vesktop-icon" {} ''
    mkdir -p $out
    cp ${../../resources/discord/discord.icns} $out/icon.icns
    cp ${../../resources/discord/discord.ico} $out/icon.ico
    cp ${../../resources/discord/discord-tray-icon.png} $out/tray-icon.png
    cp ${../../resources/discord/discord-loading.gif} $out/loading.gif
  '';

  vesktopCustom = pkgs.vesktop.overrideAttrs (oldAttrs: {
    electron = pkgs.electron_33;
    preBuild = oldAttrs.preBuild or "" + ''
      echo "Replacing icon, icns and loading animation"
      cp ${customVesktopIcon}/icon.icns build/icon.icns
      cp ${customVesktopIcon}/icon.ico static/icon.ico
      cp ${customVesktopIcon}/tray-icon.png build/icon.png
      cp ${customVesktopIcon}/tray-icon.png static/icon.png
      cp ${customVesktopIcon}/loading.gif static/shiggy.gif
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
