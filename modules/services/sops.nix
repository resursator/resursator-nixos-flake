{
  lib,
  config,
  pkgs,
  HOSTNAME ? "unknown-host",
  USERNAME,
  ...
}:
let
  hostName = HOSTNAME;
  privatekey = "ssh_${hostName}_privkey";
  publickey = "ssh_${hostName}_pubkey_unencrypted";
  secretsFile = ../../secrets/secrets.yaml;
in
{
  options.sops.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "enables sops module";
  };

  config = lib.mkIf config.sops.enable {
    environment.systemPackages = with pkgs; [
      age
      sops
      yq
    ];

    sops = {
      age.keyFile = "/home/${USERNAME}/.config/age/${hostName}.agekey";

      defaultSopsFile = secretsFile;
      defaultSopsFormat = "yaml";

      secrets = {
        ${privatekey} = {
          path = "/home/${USERNAME}/.ssh/ssh_${hostName}";
          owner = USERNAME;
        };
        ${publickey} = {
          path = "/home/${USERNAME}/.ssh/ssh_${hostName}.pub";
          owner = USERNAME;
        };
      };
    };
  };
}
