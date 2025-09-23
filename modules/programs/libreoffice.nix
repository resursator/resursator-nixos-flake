{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    libreoffice.enable = lib.mkEnableOption "enables libreoffice module";
  };

  config = lib.mkIf config.libreoffice.enable {
    environment.systemPackages = with pkgs; [
      libreoffice-qt-fresh
      hunspell
      hunspellDicts.en_US
      hunspellDicts.ru_RU
    ];
  };
}
