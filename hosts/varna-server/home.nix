{
  USERNAME,
  ...
}:

{
  home.username = USERNAME;
  home.homeDirectory = "/home/${USERNAME}";

  home.stateVersion = "24.05"; # Please read the comment before changing.
  imports = [

  ];

  home.packages = [
  ];

  home.sessionVariables = {
    FLAKE = "/home/${USERNAME}/nixosFlake";
    NH_FLAKE = "/home/${USERNAME}/nixosFlake";
  };

  home.file.".profile.d/home-manager.sh".text = ''
    if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    elif [ -f "$HOME/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh" ]; then
      . "$HOME/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh"
    fi
  '';

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      # Auto-source Home Manager session variables
      if [ -d "$HOME/.profile.d" ]; then
        for f in "$HOME/.profile.d/"*.sh; do
          [ -r "$f" ] && . "$f"
        done
      fi
    '';
  };

  programs.home-manager.enable = true;
}
