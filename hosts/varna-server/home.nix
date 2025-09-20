{
  USERNAME,
  ...
}:
{
  home.username = USERNAME;
  home.homeDirectory = "/home/${USERNAME}";

  home.stateVersion = "24.05"; # Please read the comment before changing.
  imports = [
    ../../modules/home-manager-modules/ssh-keys.nix
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

      # --- Встроенный системный bashrc из Debian ---
      # интерактивный шелл
      case $- in
          *i*) ;;
            *) return;;
      esac

      HISTCONTROL=ignoreboth
      shopt -s histappend
      HISTSIZE=1000
      HISTFILESIZE=2000
      shopt -s checkwinsize
      case "$TERM" in
          xterm-color|*-256color) color_prompt=yes;;
      esac
      if [ -n "$force_color_prompt" ]; then
          if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
              color_prompt=yes
          else
              color_prompt=
          fi
      fi
      if [ "$color_prompt" = yes ]; then
          PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
      else
          PS1="\u@\h:\$FLAKE\$ "
      fi
      unset color_prompt force_color_prompt
      case "$TERM" in
      xterm*|rxvt*)
          PS1="\[\e]0;\u@\h: \$FLAKE\a\]$PS1"
          ;;
      esac
      if [ -x /usr/bin/dircolors ]; then
          test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
          alias ls='ls --color=auto'
      fi
      if [ -f ~/.bash_aliases ]; then
          . ~/.bash_aliases
      fi
      if ! shopt -oq posix; then
        if [ -f /usr/share/bash-completion/bash_completion ]; then
          . /usr/share/bash-completion/bash_completion
        elif [ -f /etc/bash_completion ]; then
          . /etc/bash_completion
        fi
      fi
    '';
  };

  home.file.".profile".text = ''
    # Include bashrc for login shells
    if [ -n "$BASH_VERSION" ]; then
      if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
      fi
    fi

    # set PATH so it includes user's private bin if it exists
    if [ -d "$HOME/bin" ] ; then
        PATH="$HOME/bin:$PATH"
    fi
    if [ -d "$HOME/.local/bin" ] ; then
        PATH="$HOME/.local/bin:$PATH"
    fi
  '';

  programs.home-manager.enable = true;
}
