{ pkgs, ... }: {

  imports = [
    ./programs.nix
    ./ideavim.nix
  ];

  home = {
    username = "david";
    homeDirectory = "/home/david";
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "NerdFontsSymbolsOnly" ]; })

    kitty
    krita

	zsh-forgit
	zsh-fzf-history-search
	zsh-fzf-tab

    neofetch
    zip
    unzip
    curl
    wget
    openssl

    flameshot
    libreoffice-fresh

    btop
    iotop
    iftop

	libxml2
    xclip
    xdg-utils

    chromium
    jetbrains.phpstorm
    postman

    docker-compose
    gnumake
    mkcert

    php
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "23.11";
}
