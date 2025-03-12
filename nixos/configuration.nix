{
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
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
  networking.extraHosts = ''
    127.0.0.1 k3w.l
  '';

  # Set your time zone.
  time.timeZone = "Europe/Prague";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "cs_CZ.UTF-8";
    LC_IDENTIFICATION = "cs_CZ.UTF-8";
    LC_MEASUREMENT = "cs_CZ.UTF-8";
    LC_MONETARY = "cs_CZ.UTF-8";
    LC_NAME = "cs_CZ.UTF-8";
    LC_NUMERIC = "cs_CZ.UTF-8";
    LC_PAPER = "cs_CZ.UTF-8";
    LC_TELEPHONE = "cs_CZ.UTF-8";
    LC_TIME = "cs_CZ.UTF-8";
  };

  services.fprintd = {
    enable = true;
    package = pkgs.fprintd-tod;
    tod.enable = true;
    # Search for "libfprint" in packages to find other drivers
    tod.driver = pkgs.libfprint-2-tod1-broadcom;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
#  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us,cz";
  services.xserver.xkb.variant = "";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.orca.enable = false;

  hardware.bluetooth.enable = true;

  hardware.keyboard.zsa.enable = true;

  # Enable sound with pipewire.
  #  sound.enable = true;
  services.pulseaudio.enable = false;
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
  users.users.david = {
    isNormalUser = true;
    description = "david";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "plugdev"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (final: prev: {
      nvchad = inputs.nvchad4nix.packages."${pkgs.system}".nvchad;
    })
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  virtualisation = {
    docker = {
      enable = true;
      extraOptions = "  --insecure-registry artifactory.shared.kosik.systems\n  --insecure-registry artifactory.shared.kosik.systems:443\n  --insecure-registry artifactory-cr-proxy.p.shared.ne.kosik.systems\n  --insecure-registry artifactory-cr-proxy.p.shared.ne.kosik.systems:443\n";
    };
  };

  fonts.packages = [

  ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  # Enable the OpenSSH daemon.
  programs.ssh.startAgent = false;
  services.openssh = {
    enable = true;
    settings = {
      # require public key authentication for better security
      PasswordAuthentication = false;
      #permitRootLogin = "yes";
    };
  };

  #  services.auto-cpufreq.enable = true;

  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  security.pki.certificateFiles = [
    ./ssl/certs/ca/kosik-internal-ca.pem
    ./ssl/certs/ca/kosikca.pem
  ];

  #  systemd.package = pkgs.systemd.overrideAttrs (finalAttrs: previousAttrs: {
  #	version = "255.4";
  #	src = pkgs.fetchFromGitHub {
  #	  owner = "systemd";
  #	  repo = "systemd-stable";
  #	  rev = "v255.4";
  #	  hash = "sha256-P1mKq+ythrv8MU7y2CuNtEx6qCDacugzfsPRZL+NPys=";
  #	};
  #  });

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 9003 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
