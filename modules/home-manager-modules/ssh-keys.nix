{
  lib,
  config,
  pkgs,
  HOSTNAME ? "unknown-host",
  USERNAME,
  ...
}:
let
  secretsFile = ../../secrets/secrets.yaml;

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

  sshKeys = builtins.map (k: builtins.replaceStrings [ "ssh_" "_pubkey_unencrypted" ] [ "" "" ] k) (
    builtins.filter (
      k: lib.strings.hasPrefix "ssh_" k && lib.strings.hasSuffix "_pubkey_unencrypted" k
    ) (builtins.attrNames allSecrets)
  );

  sopsSecrets = builtins.listToAttrs (
    map (k: {
      name = "ssh_${k}_pubkey_unencrypted";
      value = { };
    }) sshKeys
  );

in
{
  options.ssh-keys.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "enables ssh-keys module";
  };

  config = lib.mkIf (lib.hasAttr "ssh-keys" config && config.ssh-keys.enable) {
    programs.ssh.extraConfig = ''
      Host *
        IdentityFile ~/.ssh/ssh_${HOSTNAME}
    '';

    sops = {
      defaultSopsFile = secretsFile;
      secrets = sopsSecrets;
      defaultSymlinkPath = "/run/user/${builtins.toString uid}/secrets";
      defaultSecretsMountPoint = "/run/user/${builtins.toString uid}/secrets.d";
      age.keyFile = "/run/user/${builtins.toString uid}/sops-age.txt";
    };

    home.file = lib.mkMerge (
      map (k: {
        ".secretSopsPaths/pubkeys/ssh_${k}_pubkey_unencrypted" = {
          text = config.sops.secrets."ssh_${k}_pubkey_unencrypted".path;
        };
      }) sshKeys
    );

    systemd.user.services."merge-ssh-keys" = {
      Unit = {
        Description = "Merge sops-nix ssh key secrets into authorized_keys_nix";
        After = [ "sops-nix.service" ];
      };

      Service = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "merge-ssh-keys" ''
          set -euo pipefail

          OUT="/home/${USERNAME}/.ssh/authorized_keys_nix"
          : >"$OUT"

          for f in "/home/${USERNAME}/.secretSopsPaths/pubkeys/"*; do
            [ -f "$f" ] || continue
            cat "$f" >> "$OUT"
            echo "" >> "$OUT"
          done
        '';
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
