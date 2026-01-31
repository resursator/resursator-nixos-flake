{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    kodi-iptv.enable = lib.mkEnableOption "enables kodi-iptv module";
  };

  config = lib.mkIf config.kodi-iptv.enable {
    environment.systemPackages = [
      (pkgs.kodi.withPackages (
        kodiPkgs: with kodiPkgs; [
          pvr-iptvsimple
        ]
      ))
    ];
  };
}
