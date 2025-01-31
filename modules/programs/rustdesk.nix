{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    rustdesk.enable = lib.mkEnableOption "enables rustdesk module";
  };

  config = lib.mkIf config.rustdesk.enable {
    environment.systemPackages = with pkgs; [
        rustdesk
      ];
  };
}
