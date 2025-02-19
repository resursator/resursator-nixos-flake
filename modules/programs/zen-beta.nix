{
  lib,
  config,
  pkgs,
  zenpkgs,
  ...
}:
let
  customZenIcons = pkgs.runCommand "custom-zen-icon" {} ''
    mkdir -p $out
    cp ${../../resources/zen/default16.png} $out/default16.png
    cp ${../../resources/zen/default32.png} $out/default32.png
    cp ${../../resources/zen/default48.png} $out/default48.png
    cp ${../../resources/zen/default64.png} $out/default64.png
    cp ${../../resources/zen/default128.png} $out/default128.png
  '';

  variant = "default";

  zenCustom = zenpkgs.${variant}.overrideAttrs (oldAttrs: {
    installPhase = oldAttrs.installPhase or "" + ''
      echo "Replacing icons"
      filename=$(ls $out/share/icons/hicolor/16x16/apps/)
      install -D ${customZenIcons}/default16.png $out/share/icons/hicolor/16x16/apps/$filename
      install -D ${customZenIcons}/default32.png $out/share/icons/hicolor/32x32/apps/$filename
      install -D ${customZenIcons}/default48.png $out/share/icons/hicolor/48x48/apps/$filename
      install -D ${customZenIcons}/default64.png $out/share/icons/hicolor/64x64/apps/$filename
      install -D ${customZenIcons}/default128.png $out/share/icons/hicolor/128x128/apps/$filename
    '';
  });
in
{
  options = {
    zen.enable = lib.mkEnableOption "enables zen beta module";
  };

  config = lib.mkIf config.zen.enable {
    environment.systemPackages = [
      zenCustom
    ];
  };
}
