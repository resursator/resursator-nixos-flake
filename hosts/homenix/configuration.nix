{
  HOSTNAME,
  USERNAME,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Use the GRUB 2 boot loader.
  # boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  boot.loader.systemd-boot.enable = true;

  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = HOSTNAME;
  networking.networkmanager.enable = true;
  networking.timeServers = [ "10.110.0.1" ];
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  services.xserver.xkb.model = "pc105";
  services.xserver.xkb.layout = "us,ru";
  services.xserver.xkb.options = "grp:alt_shift_toggle";

  i18n.defaultLocale = "ru_RU.UTF-8";
  console = {
    font = "cyr-sun16";
    useXkbConfig = true;
  };

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = false;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasmax11";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR pipewire (declared in services)

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${USERNAME} = {
    isNormalUser = true;
    home = "/home/${USERNAME}";
    extraGroups = [ "wheel" ];
  };

  dockerProjects.enable = true;

  # apps
  alvr.enable = true;
  dev.enable = true;
  gimp-rc.enable = true;
  messengers.enable = true;
  steam.enable = true;
  vesktopCustom.enable = true;

  # services
  amnezia.enable = true;
  ollama.enable = true;

  # sound
  pipewire.enable = true;
  pulse.enable = false;

  system.stateVersion = "24.05"; # Did you read the comment?

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "mem_sleep_default=deep"
  ];

  # Поддержка S3
  systemd.services."hibernate.target".enable = false;
  systemd.services."hybrid-sleep.target".enable = false;

  # Настройка логина для сна
  services.logind.settings.Login = {
    HandleSuspendKey = "suspend";
    HandleLidSwitch = "suspend";
    HandleHibernateKey = "ignore";
    HandleLidSwitchDocked = "ignore";
  };
}
