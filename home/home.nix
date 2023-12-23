{ pkgs, ... }: {
  
  imports = [
    ./programs
    # ./themes
  ];

  home = {
    username = "david";
    homeDirectory = "/home/david";
  };

  home.packages = with pkgs; [
    kitty

    neofetch
    fzf
    zip
    unzip

    btop
    iotop
    iftop

    xclip
    xdg-utils

    chromium
    jetbrains.phpstorm
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "23.11";
}
