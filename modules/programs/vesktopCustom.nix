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
  '';

  vesktopCustom = pkgs.vesktop.overrideAttrs (oldAttrs: {
    postInstall = oldAttrs.postInstall or "" + ''
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
