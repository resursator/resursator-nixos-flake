{
  lib,
  config,
  # USERNAME,
  HOSTNAME ? "unknown-host",
  ...
}:
let
  secretsFile = ../../secrets/secrets.yaml;
  # sshdCheckNixAuth = "^[[:space:]]*AuthorizedKeysFile[[:space:]]+\.ssh/authorized_keys[[:space:]]+\.ssh/authorized_keys_nix([[:space:]]|$)";
  # sshdWarning = "AuthorizedKeysFile .ssh/authorized_keys .ssh/authorized_keys_nix";
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
      age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    };

    home.file.".ssh/authorized_keys_nix".text =
      builtins.readFile config.sops.secrets.ssh_varna-server_pubkey_unencrypted.path;

    # home.activation.check-sshd = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    #   files="/etc/ssh/sshd_config"
    #   if [ -d /etc/ssh/sshd_config.d ]; then
    #     for f in /etc/ssh/sshd_config.d/*; do [ -f "$f" ] && files="$files $f"; done
    #   fi

    #   if ! grep -Eq '${sshdCheckNixAuth}' $files 2>/dev/null; then
    #     echo "⚠️ SSH WARNING: /etc/ssh/sshd_config не содержит строку:"
    #     echo "  ${sshdWarning}"
    #     echo "Добавь её вручную (или в /etc/ssh/sshd_config.d/10-nix-keys.conf)"
    #   fi
    # '';
  };
}
