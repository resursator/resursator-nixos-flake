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

  sshKeys = [
    "homenix"
    "homenas"
    "varna-server"
  ];
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
      secrets.ssh_homenix_pubkey_unencrypted = {
      };
      secrets.ssh_homenas_pubkey_unencrypted = {
      };
      secrets.ssh_varna-server_pubkey_unencrypted = {
      };
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
