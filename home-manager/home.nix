{ pkgs, ... }:
{
  imports = [
    ./zsh.nix
    ./kitty.nix
    ./nvchad.nix
    ./git.nix
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

    nixfmt-rfc-style
  ];

  programs.home-manager.enable = true;

  # home.sessionVariables = {
  #
  # };

  home.stateVersion = "23.11";
}
