{
  lib,
  config,
  pkgs,
  HOSTNAME ? "unknown-host",
  ...
}:
let
  hostName = HOSTNAME;
  secretsFile = ../../secrets/secrets.yaml;

in
{
  options = {
    sops.enable = lib.mkEnableOption "enables sops module";
  };

  config = lib.mkIf (lib.hasAttr "sops" config && config.sops.enable) {
    home.packages = with pkgs; [
      sops
    ];

  };
}
