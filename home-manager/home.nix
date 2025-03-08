{ pkgs, ... }: {

  imports = [
    ./programs.nix
    ./ideavim.nix
  ];

  home = {
    username = "david";
    homeDirectory = "/home/david";
  };

  home.packages = with pkgs; [
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

	php83
	k6
	nodejs
	yarn

    chromium
    brave
    jetbrains.phpstorm
    postman
    kubernetes-helm

    docker-compose
    gnumake
    mkcert

    jq
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "23.11";
}
