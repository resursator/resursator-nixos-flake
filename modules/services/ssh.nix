{
  lib,
  config,
  ...
}:
{
  options = {
    ssh.enable = lib.mkEnableOption "enables ssh module";
  };

  config = lib.mkIf config.ssh.enable {
    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

    # Open ports in the firewall.
    networking.firewall.allowedTCPPorts = [ 22 ];

    services.openssh.authorizedKeysFiles = [
      "%h/.ssh/authorized_keys_nix"
    ];
  };
}
