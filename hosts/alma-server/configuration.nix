{
  lib,
  pkgs,
  ...
}:
let
  secretsFile = ../../secrets/secrets.yaml;
  fromYAML = import (
    builtins.fetchTarball {
      url = "https://github.com/milahu/nix-yaml/archive/4b0f53d4e95e007f474d5ba7b2548d25f11c2afc.tar.gz";
      sha256 = "1bb7fywnpa8qvk5n5sd8bd5a84mlbjlh64pqbrwb02qqwds6i36w";
    }
    + "/from-yaml.nix"
  ) { inherit lib; };

  allSecrets = fromYAML (builtins.readFile secretsFile);

  sshPubkeys = lib.filterAttrs (
    name: _: lib.hasPrefix "ssh_" name && lib.hasSuffix "_pubkey_unencrypted" name
  ) allSecrets;
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Имя хоста (можно переопределить через Flake specialArgs)
  networking.hostName = "alma-server";

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
  };

  # Пользователь с ключом
  users.users.resursator = {
    isNormalUser = true;
    home = "/home/resursator";
    # shell = pkgs.zsh;
    openssh.authorizedKeys.keys = lib.attrValues sshPubkeys;
  };

  # Минимальные сервисы
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.enable = true;

  kde-home.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nvidia-drivers.enable = false;

  browser.enable = false;
  zen.enable = false;

  # services
  docker.enable = false;
  openrgb.enable = false;
  plymouth.enable = false;
  rustdesk.enable = false;

  pipewire.enable = false;

  # utils
  cliutils.enable = true;
  guiutils.enable = false;

  system.stateVersion = "25.05";
}
