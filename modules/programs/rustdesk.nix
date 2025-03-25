{
  lib,
  config,
  rustdeskpkgs,
  ...
}:
{
  options = {
    rustdesk.enable = lib.mkEnableOption "enables rustdesk module";
  };

  config = lib.mkIf config.rustdesk.enable {
    environment.systemPackages = with rustdeskpkgs; [
      rustdesk-flutter
    ];
  };
}
