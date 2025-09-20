{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    cliutils.enable = lib.mkEnableOption "enables cliutils module";
  };

  config = lib.mkIf config.cliutils.enable {
    environment.systemPackages = with pkgs; [
      git
      nh
      nil # LSP for Kate editor
      nixd # LSP for zed
      p7zip
      rar
      testdisk-qt
      ncdu
      wget
    ];
  };
}
