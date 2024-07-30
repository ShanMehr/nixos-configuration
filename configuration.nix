# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Use Nix Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  

   # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mersani = {
    isNormalUser = true;
    description = "Ishan Meher";
    extraGroups = [ "networkmanager" "wheel" "lxd"];
    packages = with pkgs; [
      thunderbird
      discord
      firefox-devedition-bin
      element-desktop
      slack
      google-chrome
      bitwarden-desktop
      obsidian
      vlc
      mautrix-whatsapp
      zoom
			gnome.pomodoro
      gnome.gnome-tweaks
      powerline-fonts
      postman
    ];
    shell = pkgs.zsh;
  };

  # environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Install firefox.
  #programs.firefox.enable = true;
  programs.mosh.enable = true;
  services.flatpak.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
   # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     nodejs
     speedtest-cli
     httperf
     iperf
     wget
     neovim
     neofetch
     vim
     git
     gcc
     mosh
     networkmanagerapplet
     tmux
     openconnect
     home-manager
     vscode
     micromamba
     oh-my-zsh
     libreoffice-qt
     hunspell
     hunspellDicts.uk_UA
     hunspellDicts.th_TH
     tmux
     unrar
     unzip
     gnomeExtensions.appindicator
  ];

  # Virtualisation
  virtualisation.lxd = {
    enable = true;
    recommendedSysctlSettings = true;
  };

  # Docker
  virtualisation.docker.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  networking.firewall.trustedInterfaces = ["lxdbr0"];
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
	services.power-profiles-daemon.enable = false;
  services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

        CPU_BOOST_ON_AC=1;
        CPU_BOOST_ON_BAT=0;
        CPU_HWP_DYN_BOOST_ON_AC=1;
        CPU_HWP_DYN_BOOST_ON_BAT=0;

        #Optional helps save long term battery health
        START_CHARGE_THRESH_BAT0 = 80; # 40 and bellow it starts to charge
        STOP_CHARGE_THRESH_BAT0 = 90; # 80 and above it stops charging
        PLATFORM_PROFILE_ON_AC="performance";
        PLATFORM_PROFILE_ON_BAT="low-power";
        SOUND_POWER_SAVE_ON_AC=1;
        SOUND_POWER_SAVE_ON_BAT=1;
        NATACPI_ENABLE=1;
        TPACPI_ENABLE=1;
        TPSMAPI_ENABLE=1;
        NMI_WATCHDOG=0;

        WIFI_PWR_ON_AC="off";
        WIFI_PWR_ON_BAT="on";
        USB_AUTOSUSPEND=1;
        MEM_SLEEP_ON_AC="s2idle";
        MEM_SLEEP_ON_BAT="deep";
      };
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    #enableAutosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    enableAutosuggestions = true;
    shellAliases = {
      ll = "ls -l";
      nix-update = "sudo nixos-rebuild switch";
      nix-clean = "sudo nix-collect-garbage -d";
      git-commit = "git add ./ && git commit && git push";
      nvim = "sudo -E nvim";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git"];
      theme = "agnoster";
    };
  };

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    ]) ++ (with pkgs.gnome; [
    epiphany # web browser
    geary # email reader
    totem # video player
    tali # poker game
    gnome-maps
    gnome-weather
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);
}
