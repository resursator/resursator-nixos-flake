{
  lib,
  config,
  pkgs,
  HOSTNAME ? "unknown-host",
  ...
}:
let
  hostName = HOSTNAME;
  hostKey = ./secrets/${hostName}.gpg.key;
in
{
  options.ssh-gpg.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable ssh-gpg module";
  };

  config = lib.mkIf (lib.hasAttr "ssh-gpg" config && config.ssh-gpg.enable) {
    home.packages = with pkgs; [
      gnupg
      pinentry
    ];

    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      defaultCacheTtl = 600;
      maxCacheTtl = 7200;

      extraConfig = ''
        ${builtins.trace (
          if lib.pathExists hostKey then
            "SSH-GPG: using key for host ${hostName}"
          else
            "SSH-GPG WARNING: no secret for host ${hostName} (expected path: ./secrets/${hostName}.gpg.key)"
        ) ""}
        ${if lib.pathExists hostKey then "KeyFile ${toString hostKey}" else ""}
      '';

    };
  };

}
