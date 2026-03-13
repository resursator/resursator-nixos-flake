{
  lib,
  config,
  pkgs,
  zenpkgs,
  ...
}:
let
  customZenIcons = pkgs.runCommand "custom-zen-icon" { } ''
    mkdir -p $out
    cp ${../../resources/zen/default16.png} $out/default16.png
    cp ${../../resources/zen/default32.png} $out/default32.png
    cp ${../../resources/zen/default48.png} $out/default48.png
    cp ${../../resources/zen/default64.png} $out/default64.png
    cp ${../../resources/zen/default128.png} $out/default128.png
  '';

  zenBase = pkgs.wrapFirefox zenpkgs.beta-unwrapped {
    icon = "zen-browser";
  };

  zenCustom = pkgs.symlinkJoin {
    name = "zen-beta";
    paths = [ zenBase ];
    postBuild = ''
      for size in 16 32 48 64 128; do
        rm -f $out/share/icons/hicolor/''${size}x''${size}/apps/zen-browser.png
        install -D ${customZenIcons}/default''${size}.png \
          $out/share/icons/hicolor/''${size}x''${size}/apps/zen-browser.png
      done
    '';
  };
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
