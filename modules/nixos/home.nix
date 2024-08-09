{ config, pkgs, inputs, ... }:

{
  home.username = "resursator";
  home.homeDirectory = "/home/resursator";

  home.stateVersion = "24.05"; # Please read the comment before changing.
  imports = [
    ./kde-config.nix
  ];

  home.packages = [
  ];

  home.file = {
    ".config/zed/settings.json".text = ''
        // Zed settings
        //
        // For information on how to configure Zed, see the Zed
        // documentation: https://zed.dev/docs/configuring-zed
        //
        // To see all of Zed's default settings without changing your
        // custom settings, run the `zed: Open Default Settings` command
        // from the command palette
        {
          "ui_font_size": 16,
          "buffer_font_size": 15,
          "theme": {
            "mode": "system",
            "light": "One Light",
            "dark": "One Dark"
          },
          "auto_update": false
        }
    '';
  };

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
  home.sessionVariables = {
    FLAKE = "/home/resursator/nixosFlake";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
