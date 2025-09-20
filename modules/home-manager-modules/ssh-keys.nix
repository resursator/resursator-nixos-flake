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
  sshdCheckNixAuth = "^[[:space:]]*AuthorizedKeysFile[[:space:]]+\.ssh/authorized_keys[[:space:]]+\.ssh/authorized_keys_nix([[:space:]]|$)";
  sshdWarning = "AuthorizedKeysFile .ssh/authorized_keys .ssh/authorized_keys_nix";
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
      secrets.ssh_varna-server_pubkey_unencrypted = {
      };
      defaultSymlinkPath = "/run/user/${builtins.toString uid}/secrets";
      defaultSecretsMountPoint = "/run/user/${builtins.toString uid}/secrets.d";
      age.keyFile = "/run/user/${builtins.toString uid}/sops-age.txt";
    };

    home.file.".secretSopsPaths/pubkeys/ssh_varna-server_pubkey_unencrypted".text =
      config.sops.secrets.ssh_varna-server_pubkey_unencrypted.path;

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
            target=$(cat "$f")
            if [ -f "$target" ]; then
              cat "$target" >>"$OUT"
              echo "" >>"$OUT"
            else
              echo "⚠ secret target $target not found" >&2
            fi
          done
        '';
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    home.activation.check-sshd = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      files="/etc/ssh/sshd_config"
      if [ -d /etc/ssh/sshd_config.d ]; then
        for f in /etc/ssh/sshd_config.d/*; do [ -f "$f" ] && files="$files $f"; done
      fi

      if ! grep -Eq '${sshdCheckNixAuth}' $files 2>/dev/null; then
        echo "⚠️ SSH WARNING: /etc/ssh/sshd_config не содержит строку:"
        echo "  ${sshdWarning}"
        echo "Добавь её вручную (или в /etc/ssh/sshd_config.d/10-nix-keys.conf)"
      fi
    '';
  };
}
