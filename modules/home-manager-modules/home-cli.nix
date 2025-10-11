{
  USERNAME,
  ...
}:

{
  home.username = USERNAME;
  home.homeDirectory = "/home/${USERNAME}";

  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = [
  ];

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/resursator/etc/profile.d/hm-session-vars.sh
  #
  # home.sessionVariables = {
  #   FLAKE = "/home/${USERNAME}/nixosFlake";
  #   NH_FLAKE = "/home/${USERNAME}/nixosFlake";
  # };
  # hm modules
  # ssh-keys.enable = false;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
