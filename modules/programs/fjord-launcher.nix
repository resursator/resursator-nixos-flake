{
  lib,
  config,
  fjordpkgs,
  ...
}:
{
  options = {
    fjord-launcher.enable = lib.mkEnableOption "enables fjord-launcher module";
  };

  config = lib.mkIf config.fjord-launcher.enable {
    environment.systemPackages = with fjordpkgs; [
      fjordlauncher
    ];
  };
}
