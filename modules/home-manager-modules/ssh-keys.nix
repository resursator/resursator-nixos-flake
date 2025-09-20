{
  lib,
  config,
  pkgs,
  HOSTNAME ? "unknown-host",
  ...
}:
let
  secretsFile = ../../secrets/secrets.yaml;
  privatekey = "ssh_${HOSTNAME}_privkey";

  uid =
    let
      uidScript = pkgs.writeScript "get-uid" ''
        #!${pkgs.runtimeShell}
        id -u
      '';
    in
    pkgs.lib.strings.toIntBase10 (
      builtins.readFile (
        pkgs.runCommand "get-uid-result" { } ''
          ${uidScript} >$out
        ''
      )
    );

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

  authorizedKeysText = lib.concatStringsSep "\n" (lib.attrValues sshPubkeys);
in
{
  options.ssh-keys.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "enables ssh-keys module";
  };

  config = lib.mkIf (lib.hasAttr "ssh-keys" config && config.ssh-keys.enable) {
    sops = {
      defaultSopsFile = secretsFile;
      secrets.${privatekey} = {
      };
      defaultSymlinkPath = "/run/user/${builtins.toString uid}/secrets";
      defaultSecretsMountPoint = "/run/user/${builtins.toString uid}/secrets.d";
      age.keyFile = "/run/user/${builtins.toString uid}/${HOSTNAME}.agekey";
    };

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."*".extraOptions = {
        IdentityFile = "/run/user/${toString uid}/secrets/${privatekey}";
      };
    };

    home.file.".ssh/.authorized_keys_nix" = {
      text = authorizedKeysText + "\n";
      recursive = true;
    };

    home.activation.fixAuthorizedKeys = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      ${pkgs.coreutils}/bin/mkdir -p ${config.home.homeDirectory}/.ssh
      ${pkgs.coreutils}/bin/rm -f ${config.home.homeDirectory}/.ssh/authorized_keys_nix
      ${pkgs.coreutils}/bin/cp ${config.home.homeDirectory}/.ssh/.authorized_keys_nix \
         ${config.home.homeDirectory}/.ssh/authorized_keys_nix
      ${pkgs.coreutils}/bin/chmod 600 ${config.home.homeDirectory}/.ssh/authorized_keys_nix
    '';
  };
}
