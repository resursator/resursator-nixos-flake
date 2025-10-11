{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    cli-small-utils.enable = lib.mkEnableOption "enables cli-small-utils module";
  };

  config = lib.mkIf config.cli-small-utils.enable {
    environment.systemPackages = with pkgs; [
      git
      mc
      micro
      nh
      p7zip
      ncdu
      wget
    ];
  };
}
