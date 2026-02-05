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
      killall
      mc
      micro
      nh
      nil # LSP for Kate editor
      nixd # LSP for zed
      openssl
      p7zip
      rar
      testdisk-qt
      ncdu
      wget
    ];
  };
}
